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

output "network_id" {
  value = random_pet.main.id
}
