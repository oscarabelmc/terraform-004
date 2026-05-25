terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_virtual_network" "prod" {
  name                = "prod-network"
  resource_group_name = "networking-rg"
}

resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = "networking-rg"
  virtual_network_name = data.azurerm_virtual_network.prod.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "app" {
  name                = "app-nic"
  location            = data.azurerm_virtual_network.prod.location
  resource_group_name = "application-rg"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "app" {
  name                = "app-vm"
  location            = data.azurerm_virtual_network.prod.location
  resource_group_name = "application-rg"
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.app.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
