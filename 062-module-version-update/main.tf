terraform {
  required_version = ">= 1.5"
}

module "compute" {
  source  = "azure/compute/azurerm"
  version = "5.2.0"

  virtual_machine_name = "version-vm"
  resource_group_name  = "version-rg"
  location             = "eastus"
}
