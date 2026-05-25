output "instance_id" {
  value = aws_instance.web.id
}

output "plan_symbols" {
  value = "+ = create, ~ = update in-place, - = destroy, -/+ = replace, <= = read"
}
