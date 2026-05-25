output "vpc_id" {
  value = aws_vpc.main.id
}

output "instance_type" {
  value = var.instance_type
}

output "validate_note" {
  value = "terraform validate checks syntax and internal consistency without contacting remote APIs."
}
