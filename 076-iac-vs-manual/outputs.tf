output "vpc_id" {
  value = aws_vpc.main.id
}

output "instance_id" {
  value = aws_instance.web.id
}

output "key_difference" {
  value = "IaC: versioned, reusable, shared config. Manual: ephemeral CLI commands, no version history, no automation."
}
