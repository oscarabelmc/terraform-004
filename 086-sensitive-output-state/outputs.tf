output "db_password" {
  value     = random_password.db_master.result
  sensitive = true
  description = "Marked sensitive — hidden in CLI, but still stored in state"
}

output "vpc_id" {
  value = aws_vpc.main.id
  description = "Not sensitive — shown normally in CLI"
}

output "reminder" {
  value = "sensitive = true only masks CLI output. The value is still in state in plain text."
}
