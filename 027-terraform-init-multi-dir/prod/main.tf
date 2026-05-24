terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_pet" "prod" {
  prefix = "prod"
  length = 2
}

output "prod_name" {
  value = random_pet.prod.id
}
