output "vpc_id" {
  value       = random_pet.vpc.id
  description = "Generated pet name used as VPC identifier"
}

output "config_file" {
  value       = local_file.config.filename
  description = "Path to the generated config file"
}

output "module_inputs" {
  value = {
    name = var.name
    cidr = var.cidr
    azs  = var.azs
  }
  description = "The input values that were passed to this module"
}
