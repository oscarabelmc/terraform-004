output "name" {
  description = "Generated pet name"
  value       = random_pet.example.id
}

output "execution_mode" {
  description = "Where this run executes"
  value       = "Local — HCP Terraform stores and syncs state only"
}
