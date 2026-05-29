output "name" {
  description = "The name of the pet"
  value       = random_pet.name.id
}

output "config_file" {
  description = "Config file path"
  value       = local_file.config.filename
}
