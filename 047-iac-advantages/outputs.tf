output "instance_id" {
  description = "The ID of the pet"
  value       = random_pet.web.id
}

output "config_file" {
  description = "The config file path"
  value       = local_file.config.filename
}
