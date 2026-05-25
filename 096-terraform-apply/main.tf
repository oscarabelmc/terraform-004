terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

variable "pet_length" {
  type    = number
  default = 2
}

resource "random_pet" "name" {
  length    = var.pet_length
  prefix    = "apply-demo"
}

resource "random_password" "db" {
  length  = 16
  special = false
}
