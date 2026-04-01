module "worker_api" {
  source = "../.."

  account_id         = var.account_id
  name               = var.worker_name
  compatibility_date = "2025-01-15"

  content_file = "${path.module}/worker.js"

  workers_dev          = true
  preview_urls_enabled = false

  plain_text_bindings = {
    ENVIRONMENT = "example"
    APP_NAME    = "demo-worker"
  }

  json_bindings = {
    APP_CONFIG = {
      app_name = "demo"
      debug    = true
      features = ["api", "metrics"]
    }
  }

  routes        = []
  cron_triggers = []
}
