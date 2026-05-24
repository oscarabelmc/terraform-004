terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

module "naming_aws" {
  source   = "./modules/naming"
  prefix   = "prod"
  env      = "aws"
  location = "us-east-1"
}

module "naming_azure" {
  source   = "./modules/naming"
  prefix   = "prod"
  env      = "azure"
  location = "eastus"
}
