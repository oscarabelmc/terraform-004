terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

import {
  to = aws_db_instance.production
  id = "manually-created-db-instance"
}

resource "aws_db_instance" "production" {
  identifier     = "manually-created-db-instance"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.medium"
  allocated_storage = 100
  db_name  = "appdb"
  username = "admin"
  password = var.db_password
  skip_final_snapshot = false

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
  }
}

variable "db_password" {
  type      = string
  sensitive = true
}
