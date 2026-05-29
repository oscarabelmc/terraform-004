output "resource_id" {
  description = "The ID of the resource"
  value       = random_pet.main.id
}

output "config_file" {
  description = "Config file path"
  value       = local_file.config.filename
}
