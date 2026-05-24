output "elastic_ip" {
  description = "Public IP address"
  value       = aws_eip.public_ip.public_ip
}

output "instance_id" {
  description = "Web server instance ID"
  value       = aws_instance.web_server.id
}

output "bucket_name" {
  description = "Company data bucket"
  value       = aws_s3_bucket.company_data.bucket
}
