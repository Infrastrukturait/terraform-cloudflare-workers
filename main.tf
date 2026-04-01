locals {
  use_wrangler = var.worker_dir != null && trimspace(var.worker_dir) != ""
  use_api      = var.content_file != null && trimspace(var.content_file) != ""

  deployment_mode = (
    local.use_wrangler && !local.use_api ? "wrangler" :
    local.use_api && !local.use_wrangler ? "api" :
    "invalid"
  )

  worker_source_files = local.deployment_mode == "wrangler" ? sort(fileset(var.worker_dir, "**")) : []

  worker_source_hash = local.deployment_mode == "wrangler" ? sha256(join("", [
    for f in local.worker_source_files : filesha256("${var.worker_dir}/${f}")
  ])) : null

  api_content_hash = local.deployment_mode == "api" && fileexists(var.content_file) ? filesha256(var.content_file) : null

  wrangler_secret_env_names = {
    for k, v in var.secret_text_bindings : k => "TF_WRANGLER_SECRET_${k}"
  }

  wrangler_secret_put_commands = join("\n", [
    for k, v in var.secret_text_bindings :
    format(
      "printf '%%s' \"$%s\" | %s secret put %s --config %s",
      local.wrangler_secret_env_names[k],
      var.wrangler_command,
      k,
      var.wrangler_config_file
    )
  ])

  secret_hash = sha256(jsonencode({
    for k, v in var.secret_text_bindings : k => sha256(nonsensitive(v))
  }))

  worker_bindings = concat(
    [
      for k, v in var.plain_text_bindings : {
        type = "plain_text"
        name = k
        text = v
      }
      if trimspace(v) != ""
    ],
    [
      for k, v in var.json_bindings : {
        type = "json"
        name = k
        json = jsonencode(v)
      }
    ],
    [
      for k, v in var.secret_text_bindings : {
        type = "secret_text"
        name = k
        text = v
      }
      if trimspace(nonsensitive(v)) != ""
    ],
    [
      for b in var.kv_namespace_bindings : {
        type         = "kv_namespace"
        name         = b.name
        namespace_id = b.namespace_id
      }
    ],
    [
      for b in var.d1_bindings : {
        type = "d1"
        name = b.name
        id   = b.database_id
      }
    ]
  )
}

resource "null_resource" "validate_inputs" {
  triggers = {
    deployment_mode = local.deployment_mode
    worker_dir      = var.worker_dir != null ? var.worker_dir : ""
    content_file    = var.content_file != null ? var.content_file : ""
  }

  lifecycle {
    precondition {
      condition     = local.deployment_mode != "invalid"
      error_message = "Exactly one of worker_dir or content_file must be set."
    }

    precondition {
      condition     = local.deployment_mode != "api" || (var.content_file != null && fileexists(var.content_file))
      error_message = "content_file must exist when API deployment is used."
    }
  }
}

resource "cloudflare_workers_script" "this" {
  count = local.deployment_mode == "api" ? 1 : 0

  account_id         = var.account_id
  script_name        = var.name
  compatibility_date = var.compatibility_date

  main_module    = basename(var.content_file)
  content_file   = var.content_file
  content_sha256 = local.api_content_hash

  bindings = local.worker_bindings

  depends_on = [null_resource.validate_inputs]
}

resource "cloudflare_workers_script_subdomain" "this" {
  count = local.deployment_mode == "api" && (var.workers_dev || var.preview_urls_enabled) ? 1 : 0

  account_id       = var.account_id
  script_name      = cloudflare_workers_script.this[0].script_name
  enabled          = var.workers_dev
  previews_enabled = var.preview_urls_enabled

  depends_on = [cloudflare_workers_script.this]
}

resource "cloudflare_workers_route" "this" {
  for_each = local.deployment_mode == "api" ? {
    for r in var.routes : "${r.zone_id}:${r.pattern}" => r
    if try(r.enabled, true)
  } : {}

  zone_id = each.value.zone_id
  pattern = each.value.pattern
  script  = cloudflare_workers_script.this[0].script_name
}

resource "cloudflare_workers_cron_trigger" "this" {
  count = local.deployment_mode == "api" && length(var.cron_triggers) > 0 ? 1 : 0

  account_id  = var.account_id
  script_name = cloudflare_workers_script.this[0].script_name

  schedules = [
    for cron in var.cron_triggers : {
      cron = cron
    }
  ]
}

resource "null_resource" "wrangler_deploy" {
  count = local.deployment_mode == "wrangler" ? 1 : 0

  triggers = {
    worker_name         = var.name
    worker_dir          = abspath(var.worker_dir)
    worker_source_hash  = local.worker_source_hash
    secret_hash         = local.secret_hash
    run_triggers_deploy = tostring(var.run_triggers_deploy)
    wrangler_config     = var.wrangler_config_file
    wrangler_command    = var.wrangler_command
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-lc"]

    environment = merge(
      {
        CLOUDFLARE_ACCOUNT_ID = var.account_id
      },
      {
        for k, v in var.secret_text_bindings :
        local.wrangler_secret_env_names[k] => nonsensitive(v)
      }
    )

    command = <<-EOT
      set -euo pipefail
      cd "${var.worker_dir}"

      if [ ! -f "${var.wrangler_config_file}" ]; then
        echo "Missing Wrangler config: ${var.wrangler_config_file}"
        exit 1
      fi

      ${length(var.secret_text_bindings) > 0 ? local.wrangler_secret_put_commands : "true"}

      ${var.wrangler_command} deploy --config ${var.wrangler_config_file}

      if [ "${var.run_triggers_deploy}" = "true" ]; then
        ${var.wrangler_command} triggers deploy --config ${var.wrangler_config_file}
      fi
    EOT
  }

  depends_on = [null_resource.validate_inputs]
}
