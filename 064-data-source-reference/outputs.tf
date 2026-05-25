output "vnet_name" {
  value = data.azurerm_virtual_network.prod.name
}

output "vnet_location" {
  value = data.azurerm_virtual_network.prod.location
}

output "subnet_id" {
  value = azurerm_subnet.app.id
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.app.name
}

output "approach" {
  value = "Data source reads existing VNet — VM resources use its attributes without modifying it."
}
