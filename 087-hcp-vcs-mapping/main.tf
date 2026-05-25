terraform {
  required_version = ">= 1.5"

  cloud {
    organization = "my-org"
    hostname     = "app.terraform.io"

    workspaces {
      name = "vcs-mapping-demo"
    }
  }
}

variable "environment" {
  type    = string
  default = "dev"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "vcs-demo-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
