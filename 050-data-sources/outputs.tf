output "release_data" {
  description = "The latest Terraform release data"
  value       = data.http.terraform_releases.response_body
}

output "pet_id" {
  description = "The ID of the pet"
  value       = random_pet.web.id
}
