output "repo_name" {
  description = "The repository name from GitHub"
  value       = data.http.prod.response_body
}

output "pet_id" {
  description = "The ID of the pet"
  value       = random_pet.app.id
}

output "config_file" {
  description = "Config file path"
  value       = local_file.config.filename
}
