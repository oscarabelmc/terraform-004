output "vpc_id" {
  value = aws_vpc.main.id
}

output "workflow_steps" {
  value = "Write → Plan → Apply"
}
