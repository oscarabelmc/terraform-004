terraform {
  required_version = ">= 1.5"
}

module "my_network" {
  source = "./modules/my_network"

  name = var.network_name
  cidr = var.network_cidr
  azs  = var.network_azs
}
