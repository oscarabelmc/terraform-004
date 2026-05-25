output "db_identifier" {
  value = aws_db_instance.production.identifier
}

output "db_endpoint" {
  value = aws_db_instance.production.endpoint
}

output "import_reason" {
  value = "Import brings manually created resources under IaC management for tracking, version control, and consistent changes."
}
