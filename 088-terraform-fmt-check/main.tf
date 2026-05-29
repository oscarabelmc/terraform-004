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

variable "environment" {
  type    = string
  default = "dev"
}

locals {
  name_prefix = "fmt-check-demo-${var.environment}"
}

resource "random_pet" "main" {
  prefix = local.name_prefix
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/result.txt"
  content  = "name = ${random_pet.main.id}"
}

output "name" {
  value = random_pet.main.id
}
