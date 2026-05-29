output "vpc_id" {
  description = "The ID of the VPC"
  value       = random_pet.main.id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = random_pet.main.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = var.vpc_cidr
}
