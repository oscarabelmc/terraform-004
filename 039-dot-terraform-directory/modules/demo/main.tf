variable "prefix" {
  description = "Prefix string"
  type        = string
}

output "prefix_result" {
  value = var.prefix
}
