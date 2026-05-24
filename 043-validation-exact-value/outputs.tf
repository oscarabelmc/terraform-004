output "instance_count" {
  description = "Number of instances created"
  value       = var.instance_count
}

output "instance_ids" {
  description = "IDs of created instances"
  value       = [for r in null_resource.web_server : r.id]
}
