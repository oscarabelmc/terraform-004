output "aws_name" {
  description = "Generated AWS resource name"
  value       = module.aws_naming.name
}

output "azure_name" {
  description = "Generated Azure resource name"
  value       = module.azure_naming.name
}
