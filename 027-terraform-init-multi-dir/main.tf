terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_pet" "root" {
  prefix = "root"
  length = 2
}

output "root_name" {
  value = random_pet.root.id
}
