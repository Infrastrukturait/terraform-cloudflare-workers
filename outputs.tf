output "name" {
  description = "Name of the deployed Cloudflare Worker script."
  value       = var.name
}

output "deployment_mode" {
  description = "Deployment mode selected by the module: 'api', 'wrangler', or 'invalid'."
  value       = local.deployment_mode
}

output "id" {
  description = "Cloudflare Worker script ID returned by the provider in API deployment mode, or null in Wrangler deployment mode."
  value       = try(cloudflare_workers_script.this[0].id, null)
}
