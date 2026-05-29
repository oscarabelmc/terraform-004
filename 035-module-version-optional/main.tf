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

module "config" {
  source = "./modules/config"

  name = "my-config"
}

resource "random_pet" "main" {
  prefix = module.config.name_result
  length = 2
}

output "pet" {
  value = random_pet.main.id
}

resource "random_pet" "main" {
  prefix = module.config.name_result
  length = 2
}

output "pet" {
  value = random_pet.main.id
}
