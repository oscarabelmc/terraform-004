output "database" {
  value = random_pet.database.id
}

output "server" {
  value = random_pet.server.id
}

output "cache" {
  value = random_pet.cache.id
}

output "queue" {
  value = random_pet.queue.id
}
