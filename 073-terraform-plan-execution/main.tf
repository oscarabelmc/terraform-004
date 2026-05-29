terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

resource "random_pet" "main" {
  count  = var.instance_count
  prefix = "plan-demo"
  length = 2
}

resource "local_file" "config" {
  count    = var.instance_count
  filename = "${path.module}/result-${count.index}.txt"
  content  = "name = ${random_pet.main[count.index].id}"
}

output "names" {
  value = random_pet.main[*].id
}
