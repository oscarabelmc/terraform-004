terraform {
  required_version = ">= 1.5"
}

module "vault-aws-tgw" {
  source  = "terraform-aws-modules/transit-gateway/aws"
  version = "3.0.3"

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
  value       = module.vault-aws-tgw.transit_gateway_attachment_id
}
