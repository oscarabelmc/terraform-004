output "server_ids" {
  value = random_pet.server[*].id
}
