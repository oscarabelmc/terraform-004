terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

module "aws_naming" {
  source   = "./modules/naming"
  prefix   = var.environment
  env      = "aws"
  location = var.aws_region
}

module "azure_naming" {
  source   = "./modules/naming"
  prefix   = var.environment
  env      = "azure"
  location = var.azure_location
}
