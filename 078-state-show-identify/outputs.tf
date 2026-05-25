output "instance_ids" {
  value = aws_instance.web[*].id
}

output "instance_names" {
  value = aws_instance.web[*].tags["Name"]
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "state_inspection" {
  value = "Use 'terraform state list' + 'terraform state show' to match managed resources against real infrastructure."
}
