output "build_tag" {
  description = "The build tag from the metadata map"
  value       = local.build_tag
}

output "pet_id" {
  description = "The ID of the pet"
  value       = random_pet.main.id
}
