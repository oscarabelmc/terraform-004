output "aws_vpc_id" {
  value = aws_vpc.main.id
}

output "azure_vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "gcp_network_id" {
  value = google_compute_network.main.id
}

output "note" {
  value = "Same HCL syntax, same workflow (init/plan/apply), same tool — across AWS, Azure, and GCP."
}
