output "instance_id" {
  value = aws_instance.application.id
}

output "instance_name" {
  value = aws_instance.application.tags["Name"]
}

output "moved_note" {
  value = "Keep moved block for at least one apply cycle so all team members update their state before removal."
}
