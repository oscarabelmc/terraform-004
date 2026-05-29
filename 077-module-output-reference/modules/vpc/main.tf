variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

resource "random_pet" "main" {
  prefix = var.name
  length = 2
}

output "vpc_id" {
  value = random_pet.main.id
}

output "default_security_group_id" {
  value = random_pet.main.id
}

output "public_subnets" {
  value = [random_pet.main.id]
}
