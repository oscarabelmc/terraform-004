output "pet_name" {
  value = random_pet.api_demo.id
}

output "provider_role" {
  value = "The provider plugin translates HCL resource declarations into API calls and maps API responses back into Terraform state."
}
