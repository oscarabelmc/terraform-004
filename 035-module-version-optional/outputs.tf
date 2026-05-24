output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "module_source" {
  description = "Module source and version"
  value = {
    source  = module.vpc.module_qualified_name
    version = module.vpc.module_version
  }
}
