output "bucket_name" {
  description = "The name of the bucket"
  value       = random_pet.data_lake.id
}

output "info_file" {
  description = "The info file path"
  value       = local_file.info.filename
}
