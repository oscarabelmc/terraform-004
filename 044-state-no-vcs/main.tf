terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_password" "database" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

resource "local_file" "config" {
  filename = "${path.module}/config.txt"
  content  = "DB_PASSWORD=${random_password.database.result}"
}

output "db_password" {
  description = "Database password (sensitive)"
  value       = random_password.database.result
  sensitive   = true
}
