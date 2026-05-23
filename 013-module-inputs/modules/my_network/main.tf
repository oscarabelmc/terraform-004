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

resource "random_pet" "vpc" {
  prefix = var.name
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/${random_pet.vpc.id}.cfg"
  content  = <<-EOT
    name: ${var.name}
    cidr: ${var.cidr}
    azs: ${join(", ", var.azs)}
    pet_suffix: ${random_pet.vpc.id}
  EOT
}
