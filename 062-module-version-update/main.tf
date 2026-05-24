terraform {
  required_version = ">= 1.5"
}

module "compute" {
  source  = "azure/compute/azurerm"
  version = "5.2.0"

  virtual_machine_name = "btk-vm"
  resource_group_name  = "btk-rg"
  location             = "eastus"
}
