output "server" {
  value = random_pet.server.id
}

output "client" {
  value = random_pet.client.id
}

output "server_file" {
  value = local_file.server_info.filename
}

output "client_file" {
  value = local_file.client_info.filename
}
