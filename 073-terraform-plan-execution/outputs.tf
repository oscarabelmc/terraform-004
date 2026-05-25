output "vpc_id" {
  value = aws_vpc.main.id
}

output "instance_ids" {
  value = aws_instance.web[*].id
}

output "plan_note" {
  value = "terraform plan compares state vs config, shows execution plan, makes zero changes."
}
