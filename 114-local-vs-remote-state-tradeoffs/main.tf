terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  # No backend block = local state (default)
}

resource "random_pet" "demo" {
  length = 2
}
