output "ami_id" {
  description = "Queried AMI ID"
  value       = data.aws_ami.btk-app.id
}

output "ami_name" {
  description = "Queried AMI name"
  value       = data.aws_ami.btk-app.name
}

output "instance_ami" {
  description = "AMI used by the instance"
  value       = aws_instance.web.ami
}
