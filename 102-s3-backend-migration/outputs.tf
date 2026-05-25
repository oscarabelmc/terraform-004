output "pet_name" {
  value = random_pet.backend_demo.id
}

output "backend_note" {
  value = "Add backend \"s3\" block, then terraform init to migrate state from local to S3."
}
