
# terraform-cloudflare-workers

[![WeSupportUkraine](https://raw.githubusercontent.com/Infrastrukturait/WeSupportUkraine/main/banner.svg)](https://github.com/Infrastrukturait/WeSupportUkraine)
## About
Terraform module to provision a [CloudFlare workers](https://developers.cloudflare.com/workers/).
## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

```text
The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Source: <https://opensource.org/licenses/MIT>
```
See [LICENSE](LICENSE) for full details.
## Authors
- Rafał Masiarek | [website](https://masiarek.pl) | [email](mailto:rafal@masiarek.pl) | [github](https://github.com/rafalmasiarek)
<!-- BEGIN_TF_DOCS -->
## Documentation


### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 5.18.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.1 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [cloudflare_workers_cron_trigger.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/workers_cron_trigger) | resource |
| [cloudflare_workers_route.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/workers_route) | resource |
| [cloudflare_workers_script.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/workers_script) | resource |
| [cloudflare_workers_script_subdomain.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/workers_script_subdomain) | resource |
| [null_resource.validate_inputs](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wrangler_deploy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Cloudflare account ID where the Worker script will be deployed. | `string` | n/a | yes |
| <a name="input_compatibility_date"></a> [compatibility\_date](#input\_compatibility\_date) | Compatibility date for the Worker runtime in YYYY-MM-DD format. | `string` | n/a | yes |
| <a name="input_content_file"></a> [content\_file](#input\_content\_file) | Path to the built Worker entry file. Use this for provider/API deployment mode. | `string` | `null` | no |
| <a name="input_cron_triggers"></a> [cron\_triggers](#input\_cron\_triggers) | List of cron schedule expressions to configure for the Worker in API deployment mode. | `list(string)` | `[]` | no |
| <a name="input_d1_bindings"></a> [d1\_bindings](#input\_d1\_bindings) | List of D1 database bindings to attach to the Worker. | <pre>list(object({<br>    name        = string<br>    database_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_json_bindings"></a> [json\_bindings](#input\_json\_bindings) | Map of JSON bindings exposed to the Worker. | `map(any)` | `{}` | no |
| <a name="input_kv_namespace_bindings"></a> [kv\_namespace\_bindings](#input\_kv\_namespace\_bindings) | List of KV namespace bindings to attach to the Worker. | <pre>list(object({<br>    name         = string<br>    namespace_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Cloudflare Worker script. | `string` | n/a | yes |
| <a name="input_plain_text_bindings"></a> [plain\_text\_bindings](#input\_plain\_text\_bindings) | Map of plain text bindings exposed to the Worker as text variables. | `map(string)` | `{}` | no |
| <a name="input_preview_urls_enabled"></a> [preview\_urls\_enabled](#input\_preview\_urls\_enabled) | Whether to enable preview URLs for the Worker in API deployment mode. | `bool` | `false` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | List of route definitions to attach to the Worker in API deployment mode. | <pre>list(object({<br>    zone_id = string<br>    pattern = string<br>    enabled = optional(bool, true)<br>  }))</pre> | `[]` | no |
| <a name="input_run_triggers_deploy"></a> [run\_triggers\_deploy](#input\_run\_triggers\_deploy) | Whether to run 'wrangler triggers deploy' after 'wrangler deploy' in Wrangler deployment mode. | `bool` | `true` | no |
| <a name="input_secret_text_bindings"></a> [secret\_text\_bindings](#input\_secret\_text\_bindings) | Map of secret text bindings to attach to the Worker. In Wrangler mode, these are uploaded with 'wrangler secret put'. | `map(string)` | `{}` | no |
| <a name="input_worker_dir"></a> [worker\_dir](#input\_worker\_dir) | Path to the Wrangler project directory containing the Wrangler configuration file. Use this for Wrangler deployment mode. | `string` | `null` | no |
| <a name="input_workers_dev"></a> [workers\_dev](#input\_workers\_dev) | Whether to enable the workers.dev subdomain for the Worker in API deployment mode. | `bool` | `false` | no |
| <a name="input_wrangler_command"></a> [wrangler\_command](#input\_wrangler\_command) | Command used to execute Wrangler. | `string` | `"npx -y wrangler@4"` | no |
| <a name="input_wrangler_config_file"></a> [wrangler\_config\_file](#input\_wrangler\_config\_file) | Wrangler configuration file name located inside worker\_dir. | `string` | `"wrangler.toml"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_deployment_mode"></a> [deployment\_mode](#output\_deployment\_mode) | Deployment mode selected by the module: 'api', 'wrangler', or 'invalid'. |
| <a name="output_id"></a> [id](#output\_id) | Cloudflare Worker script ID returned by the provider in API deployment mode, or null in Wrangler deployment mode. |
| <a name="output_name"></a> [name](#output\_name) | Name of the deployed Cloudflare Worker script. |

### Examples

```hcl
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
```

<!-- END_TF_DOCS -->


<!-- references -->

[repo_link]: https://github.com/Infrastrukturait/terraform-cloudflare-workers
