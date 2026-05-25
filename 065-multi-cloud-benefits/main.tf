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
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  features {}
}

provider "google" {
  project = "my-project"
  region  = "us-central1"
}

# AWS resources
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "multi-cloud-demo" }
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id

  tags = { Name = "web-aws" }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

# Azure resources
resource "azurerm_resource_group" "main" {
  name     = "multi-cloud-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "main" {
  name                = "multi-cloud-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.1.0.0/16"]
}

# GCP resources
resource "google_compute_network" "main" {
  name                    = "multi-cloud-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = "multi-cloud-subnet"
  network       = google_compute_network.main.id
  region        = "us-central1"
  ip_cidr_range = "10.2.0.0/16"
}
