output "vpc_id" {
  value = aws_vpc.main.id
}

output "sg_id" {
  value = aws_security_group.web.id
}

output "run_task_note" {
  value = "HCP Terraform run tasks integrate external tools (security scanners, policy checks) between plan and apply."
}
