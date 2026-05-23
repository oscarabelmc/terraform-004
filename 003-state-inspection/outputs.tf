output "server_name" {
  value = random_pet.server.id
}

output "file_path" {
  value = local_file.server_info.filename
}
