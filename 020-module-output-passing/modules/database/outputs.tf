output "connection_string" {
  value       = "postgresql://${random_pet.db.id}.example.com:5432/${random_pet.db.id}"
  description = "Full database connection string"
}

output "db_host" {
  value       = "${random_pet.db.id}.example.com"
  description = "Database hostname"
}

output "db_port" {
  value       = 5432
  description = "Database port"
}
