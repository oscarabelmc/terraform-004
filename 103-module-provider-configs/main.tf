terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# Default provider — child modules inherit this automatically
provider "random" {
}

# Aliased provider for explicit passing
provider "random" {
  alias = "west"
}

# Child module inherits default provider automatically
module "default" {
  source = "./modules/child"
}

# Child module receives explicit provider via providers argument
module "explicit" {
  source = "./modules/child"
  providers = {
    random = random.west
  }
}
