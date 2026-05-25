output "vpc_id" {
  value = aws_vpc.main.id
}

output "instance_id" {
  value = aws_instance.web.id
}

output "environment" {
  value = var.environment
}

output "iac_benefits" {
  value = "Same code, different envs: consistent, repeatable, automated, easy to learn, disaster recovery ready."
}
