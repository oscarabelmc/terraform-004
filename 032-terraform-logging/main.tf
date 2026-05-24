terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_pet" "example" {
  prefix = "log-test"
  length = 2
}

output "name" {
  value = random_pet.example.id
}
