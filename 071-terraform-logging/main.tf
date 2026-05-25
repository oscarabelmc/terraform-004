terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "environment" {
  type    = string
  default = "dev"
}

locals {
  name_prefix = "log-demo-${var.environment}"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = local.name_prefix
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${local.name_prefix}-subnet"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "${local.name_prefix}-web"
  }
}
