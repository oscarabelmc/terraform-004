output "password" {
  description = "The database password"
  value       = random_password.db_master.result
  sensitive   = true
}
