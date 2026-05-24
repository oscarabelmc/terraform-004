output "instance_id" {
  description = "ID of the web server instance"
  value       = aws_instance.web.id
}

output "security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web_sg.id
}

output "declarative_note" {
  value = "IaC is declarative, not imperative. We define what we want, not how to do it."
}
