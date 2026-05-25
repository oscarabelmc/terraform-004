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

resource "random_pet" "example" {
  length = 3
}

resource "local_file" "example" {
  filename = "${path.module}/example.txt"
  content  = random_pet.example.id
}
