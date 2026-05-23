terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

variable "name" {
  description = "Name prefix for the resource"
  type        = string
}

resource "random_pet" "this" {
  prefix = var.name
  length = 2
}

output "id" {
  value = random_pet.this.id
}
