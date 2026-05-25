output "db_endpoint" {
  value = aws_db_instance.main.endpoint
  description = "Database endpoint - not sensitive"
}

output "db_password" {
  value     = random_password.db_master.result
  sensitive = true
  description = "Database password - marked sensitive (masked in CLI, still in state)"
}

output "state_security_note" {
  value = <<-EOT
    Sensitive data in state:
    - Random password IS stored in state (plain text)
    - sensitive = true only hides CLI output
    - Remote backend with encryption + access controls is essential
    - Local state is plain text - never commit to VCS
  EOT
}
