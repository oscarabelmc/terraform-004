terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

locals {
  names_str = join(", ", var.names)
  tags_str  = join(", ", [for k, v in var.tags : "${k}=${v}"])
}

resource "local_file" "config" {
  content  = <<-EOT
    Instance count: ${var.instance_count}
    Enabled: ${var.enabled}
    Tags: ${local.tags_str}
  EOT
  filename = "${path.module}/config.txt"
}
