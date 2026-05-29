terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_pet" "main" {
  prefix = "gitignore-demo"
  length = 2
}

output "id" {
  value = random_pet.main.id
}
