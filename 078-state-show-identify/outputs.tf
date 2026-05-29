output "vpc_id" {
  description = "The VPC ID"
  value       = random_pet.main.id
}

output "web_ids" {
  description = "The IDs of the web resources"
  value       = random_pet.web[*].id
}
