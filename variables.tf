variable "account_id" {
  type        = string
  description = "Cloudflare account ID where the Worker script will be deployed."
}

variable "name" {
  type        = string
  description = "Name of the Cloudflare Worker script."
}

variable "compatibility_date" {
  type        = string
  description = "Compatibility date for the Worker runtime in YYYY-MM-DD format."
}

variable "content_file" {
  type        = string
  default     = null
  description = "Path to the built Worker entry file. Use this for provider/API deployment mode."
}

variable "worker_dir" {
  type        = string
  default     = null
  description = "Path to the Wrangler project directory containing the Wrangler configuration file. Use this for Wrangler deployment mode."
}

variable "wrangler_config_file" {
  type        = string
  default     = "wrangler.toml"
  description = "Wrangler configuration file name located inside worker_dir."
}

variable "run_triggers_deploy" {
  type        = bool
  default     = true
  description = "Whether to run 'wrangler triggers deploy' after 'wrangler deploy' in Wrangler deployment mode."
}

variable "wrangler_command" {
  type        = string
  default     = "npx -y wrangler@4"
  description = "Command used to execute Wrangler."
}

variable "workers_dev" {
  type        = bool
  default     = false
  description = "Whether to enable the workers.dev subdomain for the Worker in API deployment mode."
}

variable "preview_urls_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable preview URLs for the Worker in API deployment mode."
}

variable "routes" {
  type = list(object({
    zone_id = string
    pattern = string
    enabled = optional(bool, true)
  }))
  default     = []
  description = "List of route definitions to attach to the Worker in API deployment mode."
}

variable "cron_triggers" {
  type        = list(string)
  default     = []
  description = "List of cron schedule expressions to configure for the Worker in API deployment mode."
}

variable "plain_text_bindings" {
  type        = map(string)
  default     = {}
  description = "Map of plain text bindings exposed to the Worker as text variables."
}

variable "json_bindings" {
  type        = map(any)
  default     = {}
  description = "Map of JSON bindings exposed to the Worker."
}

variable "kv_namespace_bindings" {
  type = list(object({
    name         = string
    namespace_id = string
  }))
  default     = []
  description = "List of KV namespace bindings to attach to the Worker."
}

variable "d1_bindings" {
  type = list(object({
    name        = string
    database_id = string
  }))
  default     = []
  description = "List of D1 database bindings to attach to the Worker."
}

variable "secret_text_bindings" {
  type        = map(string)
  default     = {}
  sensitive   = true
  description = "Map of secret text bindings to attach to the Worker. In Wrangler mode, these are uploaded with 'wrangler secret put'."
}
