output "server_id" {
  value = random_pet.server.id
}

output "file_path" {
  value = local_file.config.filename
}
