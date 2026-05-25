terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-prod"
    key            = "sensitive-demo/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

resource "random_password" "db_master" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "main" {
  identifier     = "sensitive-demo-db"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  allocated_storage = 20

  db_name  = "appdb"
  username = "admin"
  password = random_password.db_master.result

  skip_final_snapshot = true
}

resource "aws_iam_user" "deploy" {
  name = "sensitive-demo-deploy"
}

resource "aws_iam_user_login_profile" "deploy" {
  user    = aws_iam_user.deploy.name
  pgp_key = "keybase:my_username"
}

output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "db_password" {
  value     = random_password.db_master.result
  sensitive = true
}
