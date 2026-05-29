terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "random_password" "db_master" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "local_file" "config" {
  filename = "${path.module}/app-config.txt"
  content  = <<-EOT
    DB_URL=mysql://admin:${random_password.db_master.result}@localhost:3306/appdb
    DB_PASSWORD=${random_password.db_master.result}
  EOT
}

resource "random_pet" "deploy" {
  prefix = "sensitive-demo"
  length = 2
}

output "db_password" {
  value     = random_password.db_master.result
  sensitive = true
}

output "deploy_user" {
  value = random_pet.deploy.id
}
