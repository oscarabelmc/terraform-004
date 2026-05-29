variable "name" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

resource "random_pet" "instance" {
  count  = var.instance_count
  prefix = var.name
  length = 2
}

output "instance_ids" {
  value = random_pet.instance[*].id
}
