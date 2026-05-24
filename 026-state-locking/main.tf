terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "terraform-004/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}

resource "random_pet" "server" {
  prefix = "locked"
  length = 2
}

output "server_name" {
  value = random_pet.server.id
}
