output "elastic_ip" {
  description = "Public IP address"
  value       = local_file.public_ip.filename
}

output "instance_id" {
  description = "Web server instance ID"
  value       = random_pet.web_server.id
}

output "bucket_name" {
  description = "Company data bucket"
  value       = random_pet.company_data.id
}
