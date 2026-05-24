variable "db_password" {
  description = "Database password — provided at runtime, never hardcoded"
  type        = string
  sensitive   = true
}
