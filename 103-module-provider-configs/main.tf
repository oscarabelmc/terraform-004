terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Default provider — child modules inherit this automatically
provider "aws" {
  region = "us-east-1"
}

# Aliased provider for explicit passing
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

# Child module inherits default provider automatically
module "default" {
  source = "./modules/child"
}

# Child module receives explicit provider via providers argument
module "explicit" {
  source    = "./modules/child"
  providers = {
    aws = aws.west
  }
}
