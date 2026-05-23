terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

resource "random_pet" "my_pet" {
  prefix = "exam"
  length = 2
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}
