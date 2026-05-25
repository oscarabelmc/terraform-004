output "pet_name" {
  value = random_pet.demo.id
}

output "plugin_note" {
  value = "A provider is a plugin — a separate executable binary that Terraform Core launches to interact with infrastructure APIs."
}
