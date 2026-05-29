output "instance_id" {
  description = "The ID of the instance pet"
  value       = random_pet.app_core.id
}

output "volume_id" {
  description = "The ID of the data pet"
  value       = random_pet.data_volume.id
}

output "attachment_file" {
  description = "The attachment file path"
  value       = local_file.attachment.filename
}

output "attachment_info" {
  description = "Volume attachment details"
  value = {
    device   = local_file.attachment.filename
    instance = random_pet.app_core.id
    volume   = random_pet.data_volume.id
  }
}
