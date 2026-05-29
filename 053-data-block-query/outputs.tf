output "repo_data" {
  description = "The repository data from GitHub"
  value       = data.http.example.response_body
}

output "pet_id" {
  description = "The ID of the pet"
  value       = random_pet.web.id
}
