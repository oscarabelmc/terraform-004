output "resource_id" {
  value = random_pet.main.id
}

output "config_file" {
  value = local_file.config.filename
}

output "locking_info" {
  value = "S3 backend supports locking via DynamoDB. Not all backends support locking by default."
}
