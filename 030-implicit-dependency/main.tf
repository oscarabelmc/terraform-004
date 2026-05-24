terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_s3_bucket" "company_data" {
  bucket = "company-data-bucket"
}

resource "aws_instance" "web_server" {
  ami           = "ami-502b7f631"
  instance_type = "t2.micro"
  depends_on    = [aws_s3_bucket.company_data]
}

resource "aws_eip" "public_ip" {
  vpc      = true
  instance = aws_instance.web_server.id
}
