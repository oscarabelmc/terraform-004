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

module "config" {
  source = "./modules/config"

  client_id      = var.tgw_client
  hvn_id         = var.hvn
  route_table_id = var.rtb_id
}

variable "tgw_client" {
  description = "HCP Vault client ID"
  type        = string
}

variable "hvn" {
  description = "HCP HVN ID"
  type        = string
}

variable "rtb_id" {
  description = "Route table ID"
  type        = string
}

output "transit_gateway_id" {
  description = "The ID of the Transit Gateway attachment"
  value       = module.config.transit_gateway_attachment_id
}
