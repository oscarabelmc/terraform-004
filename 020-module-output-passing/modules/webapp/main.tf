terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "db_connection_str" {
  description = "Database connection string from the database module"
  type        = string
}

resource "local_file" "config" {
  filename = "${path.module}/app-config.txt"
  content  = <<-EOT
    DATABASE_URL=${var.db_connection_str}
    APP_MODE=production
  EOT
}

output "config_file" {
  value = local_file.config.filename
}
