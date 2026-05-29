output "names" {
  description = "The names of the resources"
  value       = random_pet.main[*].id
}
