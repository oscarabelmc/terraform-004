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

resource "random_pet" "subnets" {
  count  = length(var.subnet_cidrs)
  prefix = element(var.subnet_cidrs, count.index)
  length = 1
}

resource "local_file" "summary" {
  filename = "${path.module}/subnet-count.txt"
  content  = <<-EOT
    Total subnets: ${length(var.subnet_cidrs)}
    CIDRs: ${join(", ", var.subnet_cidrs)}
    Large deployment: ${length(var.subnet_cidrs) > 5}
  EOT
}
