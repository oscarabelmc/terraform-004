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

  backend "s3" {
    bucket         = "terraform-state-prod"
    key            = "locking-demo/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

resource "random_pet" "main" {
  prefix = "locking"
  length = 2
}

resource "local_file" "config" {
  filename = "${path.module}/config.txt"
  content  = "resource_id = ${random_pet.main.id}"
}
