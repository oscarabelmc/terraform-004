terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Default provider configuration (no alias)
provider "aws" {
  region = "us-east-1"
}

# Second provider configuration — causes duplicate error without alias
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "web_us" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "web-us-east"
  }
}

resource "aws_instance" "web_mumbai" {
  ami           = "ami-0c55b159cbfafe1f1"
  instance_type = "t2.micro"

  tags = {
    Name = "web-mumbai"
  }
}
