variable "account_id" {
  type        = string
  description = "Cloudflare account ID where the example Worker will be deployed."
}

variable "worker_name" {
  type        = string
  default     = "example-api-worker"
  description = "Name of the example Worker."
}
