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
}

resource "random_pet" "aws_vpc" {
  prefix = "aws"
  length = 2
}

resource "random_pet" "aws_instance" {
  prefix     = "aws-web"
  length     = 2
  depends_on = [random_pet.aws_vpc]
}

resource "random_pet" "aws_subnet" {
  prefix     = "aws-subnet"
  length     = 2
  depends_on = [random_pet.aws_vpc]
}

resource "random_pet" "azure_rg" {
  prefix = "azure"
  length = 2
}

resource "random_pet" "azure_vnet" {
  prefix     = "azure-vnet"
  length     = 2
  depends_on = [random_pet.azure_rg]
}

resource "random_pet" "gcp_network" {
  prefix = "gcp"
  length = 2
}

resource "random_pet" "gcp_subnet" {
  prefix     = "gcp-subnet"
  length     = 2
  depends_on = [random_pet.gcp_network]
}
