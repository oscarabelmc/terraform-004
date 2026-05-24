terraform {
  required_version = ">= 1.5"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

resource "null_resource" "web_server" {
  count = var.instance_count

  triggers = {
    instance_number = count.index + 1
  }
}
