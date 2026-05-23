output "module_vpc_id" {
  value       = module.my_network.vpc_id
  description = "VPC identifier from the child module"
}

output "module_config_file" {
  value       = module.my_network.config_file
  description = "Config file path from the child module"
}

output "module_received_inputs" {
  value       = module.my_network.module_inputs
  description = "The input values the child module received"
}
