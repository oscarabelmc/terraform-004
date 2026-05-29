# This module DEFINES its own provider block.
# This makes it incompatible with for_each, count, and depends_on.

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "random" {
}

resource "random_pet" "main" {
  prefix = "self-provider"
  length = 2
}

output "id" {
  value = random_pet.main.id
}
