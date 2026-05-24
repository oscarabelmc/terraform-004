terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_password" "db" {
  length  = 16
  special = true
}

# Using a sensitive variable — value provided at runtime
resource "local_file" "config" {
  filename = "${path.module}/app-config.txt"
  content  = <<-EOT
    DB_URL=postgres://user:${var.db_password}@localhost:5432/app
    DB_PASSWORD=${var.db_password}
  EOT
}
