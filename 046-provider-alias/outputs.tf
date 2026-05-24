output "us_instance_id" {
  description = "ID of the us-east-1 instance"
  value       = aws_instance.web_us.id
}

output "mumbai_instance_id" {
  description = "ID of the ap-south-1 instance"
  value       = aws_instance.web_mumbai.id
}

output "us_region" {
  description = "Region of the default provider"
  value       = "us-east-1"
}

output "mumbai_region" {
  description = "Region of the aliased provider"
  value       = "ap-south-1"
}
