output "instance_count" {
  description = "Number of instances"
  value       = var.instance_count
}

output "instance_ids" {
  description = "IDs of created null resources"
  value       = [for r in null_resource.example : r.id]
}
