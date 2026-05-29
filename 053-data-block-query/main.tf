terraform {
  required_version = ">= 1.5"
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

data "http" "example" {
  url = "https://api.github.com/repos/hashicorp/terraform"
}

resource "random_pet" "web" {
  prefix = "data"
  length = 2
}


