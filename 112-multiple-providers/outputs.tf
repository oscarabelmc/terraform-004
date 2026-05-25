output "server_name" {
  value = random_pet.server.id
}

output "config_file" {
  value = local_file.config.filename
}

output "answer" {
  value = "True — multiple providers can be declared in a single Terraform configuration file."
}
