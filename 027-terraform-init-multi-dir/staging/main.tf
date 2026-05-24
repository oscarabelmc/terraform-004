terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_pet" "staging" {
  prefix = "staging"
  length = 2
}

output "staging_name" {
  value = random_pet.staging.id
}
