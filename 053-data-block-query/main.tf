terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_ami" "btk-app" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Owner"
    values = ["btk-platform"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.btk-app.id
  instance_type = "m6g.xlarge"

  tags = {
    Name = "btk-web-server"
  }
}
