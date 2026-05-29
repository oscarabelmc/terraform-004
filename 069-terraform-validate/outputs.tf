output "name" {
  description = "The name of the resource"
  value       = random_pet.main.id
}

output "result_file" {
  description = "The result file path"
  value       = local_file.config.filename
}
