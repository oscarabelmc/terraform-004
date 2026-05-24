output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "instance_id" {
  value = aws_instance.web.id
}

output "plan_explanation" {
  value = "Terraform compares desired state (config) with current state (state file) to determine what to create, update, or destroy."
}
