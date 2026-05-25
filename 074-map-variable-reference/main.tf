terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "metadata" {
  type = map(string)
  default = {
    owner     = "platform"
    build-tag = "v5.0.2"
    service   = "billing"
  }
}

locals {
  build_tag = var.metadata["build-tag"]
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name    = "app-${local.build_tag}"
    Owner   = var.metadata["owner"]
    Service = var.metadata["service"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name      = "web-${local.build_tag}"
    BuildTag  = var.metadata["build-tag"]
  }
}
