terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_ami" "example" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Owner"
    values = ["data-platform"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.example.id
  instance_type = "m6g.xlarge"

  tags = {
    Name = "data-web-server"
  }
}
