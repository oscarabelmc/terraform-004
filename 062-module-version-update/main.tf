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

module "compute" {
  source = "./modules/compute"

  name = "version-vm"
}

resource "random_pet" "main" {
  prefix = module.compute.name_result
  length = 2
}

output "pet" {
  value = random_pet.main.id
}
