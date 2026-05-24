output "ami_id" {
  description = "The ID of the fetched AMI"
  value       = data.aws_ami.ubuntu.id
}

output "ami_name" {
  description = "The name of the fetched AMI"
  value       = data.aws_ami.ubuntu.name
}

output "instance_ami_used" {
  description = "The AMI used by the instance"
  value       = aws_instance.web.ami
}
