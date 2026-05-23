output "subnet_count" {
  value       = length(var.subnet_cidrs)
  description = "Number of subnets"
}

output "is_large_deployment" {
  value       = length(var.subnet_cidrs) > 5
  description = "True if more than 5 subnets"
}

output "all_subnet_pets" {
  value       = random_pet.subnets[*].id
  description = "Generated pet names mapped to each subnet"
}
