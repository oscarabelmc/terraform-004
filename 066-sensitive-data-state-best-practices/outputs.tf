output "db_password" {
  description = "The database password"
  value       = random_password.db_master.result
  sensitive   = true
}

output "deploy_user" {
  description = "The deploy user name"
  value       = random_pet.deploy.id
}

output "config_file" {
  description = "Config file path"
  value       = local_file.config.filename
}
