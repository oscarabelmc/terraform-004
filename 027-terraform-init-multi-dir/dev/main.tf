terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_pet" "dev" {
  prefix = "dev"
  length = 2
}

output "dev_name" {
  value = random_pet.dev.id
}
