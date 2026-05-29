terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_pet" "vpc" {
  prefix = "vpc"
  length = 2
}

resource "random_pet" "subnet" {
  prefix = "subnet"
  length = 2
}

resource "random_pet" "instance" {
  prefix = "instance"
  length = 2
}
