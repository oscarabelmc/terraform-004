output "db_password" {
  value     = var.db_password
  sensitive = true
}

output "server" {
  value = random_pet.server.id
}
