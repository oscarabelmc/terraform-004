output "vpc_id" {
  value = aws_vpc.main.id
}

output "instance_id" {
  value = aws_instance.web.id
}

output "validate_note" {
  value = "After refactoring, run 'terraform validate' for fast syntax and reference checking."
}
