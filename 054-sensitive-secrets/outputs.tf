output "db_password" {
  description = "Database password (redacted in CLI)"
  value       = var.db_password
  sensitive   = true
}

output "generated_password" {
  description = "Generated password (redacted in CLI)"
  value       = random_password.db.result
  sensitive   = true
}

output "note" {
  value = "Secrets are redacted in CLI output but stored in plaintext in state"
}
