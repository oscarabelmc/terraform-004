variable "name" {
  type = string
}

resource "random_pet" "main" {
  prefix = var.name
  length = 2
}

output "name_result" {
  value = random_pet.main.id
}
