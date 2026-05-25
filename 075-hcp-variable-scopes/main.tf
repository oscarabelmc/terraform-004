terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = "my-org"
    hostname     = "app.terraform.io"

    workspaces {
      name = "variable-scope-demo"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "common_tags" {
  type = map(string)
  default = {
    ManagedBy = "Terraform"
    Owner     = "platform-team"
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(var.common_tags, { Environment = var.environment })
}
