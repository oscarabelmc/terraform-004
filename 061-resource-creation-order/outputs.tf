output "instance_name" {
  description = "The name of the instance"
  value       = random_pet.web.id
}

output "attachment_file" {
  description = "The attachment file path"
  value       = local_file.data.filename
}
