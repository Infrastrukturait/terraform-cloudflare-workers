output "worker_name" {
  description = "Name of the deployed example Worker."
  value       = module.worker_api.name
}

output "deployment_mode" {
  description = "Deployment mode used by the example module."
  value       = module.worker_api.deployment_mode
}

output "worker_id" {
  description = "Worker ID returned by the module in API deployment mode."
  value       = module.worker_api.id
}
