terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}

resource "time_sleep" "wait" {
  create_duration = "1s"
}

resource "aws_s3_bucket" "data" {
  bucket = "example-bucket-${time_sleep.wait.id}"
}
