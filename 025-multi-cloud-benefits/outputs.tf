output "aws_name" {
  description = "Generated AWS resource name"
  value       = module.naming_aws.name
}

output "azure_name" {
  description = "Generated Azure resource name"
  value       = module.naming_azure.name
}
