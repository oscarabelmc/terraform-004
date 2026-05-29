output "web_us_id" {
  description = "The ID of the us pet"
  value       = random_pet.web_us.id
}

output "web_mumbai_id" {
  description = "The ID of the mumbai pet"
  value       = random_pet.web_mumbai.id
}
