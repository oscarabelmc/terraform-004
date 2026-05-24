output "server" {
  value = random_pet.server.id
}

output "file" {
  value = local_file.info.filename
}
