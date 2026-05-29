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

resource "random_pet" "main" {
  prefix = "main"
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/config.txt"
  content  = "vpc_id = ${random_pet.main.id}"
}

output "id" {
  value = random_pet.main.id
}
