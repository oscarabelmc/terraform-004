output "server" {
  value = random_pet.server.id
}

output "file" {
  value = local_file.server_info.filename
}
