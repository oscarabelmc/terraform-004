output "server_name" {
  description = "Generated server name"
  value       = random_pet.server.id
}

output "note" {
  value = "Use 'terraform plan -out=plan.tfplan' and 'terraform apply plan.tfplan' for change management"
}
