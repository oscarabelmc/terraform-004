output "vpc_id" {
  description = "The ID of the VPC"
  value       = random_pet.main.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = var.cidr
}
