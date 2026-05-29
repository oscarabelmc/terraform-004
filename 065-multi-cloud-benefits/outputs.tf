output "aws_vpc_id" {
  value = random_pet.aws_vpc.id
}

output "azure_vnet_id" {
  value = random_pet.azure_vnet.id
}

output "gcp_network_id" {
  value = random_pet.gcp_network.id
}

output "note" {
  value = "Same HCL syntax, same workflow (init/plan/apply), same tool — across AWS, Azure, and GCP."
}
