terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

module "example" {
  source = "./modules/demo"
  prefix = "dot-terraform"
}

resource "random_pet" "main" {
  prefix = module.example.prefix_result
  length = 2
}

output "name" {
  value = random_pet.main.id
}
