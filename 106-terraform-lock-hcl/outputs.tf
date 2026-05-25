output "pet_name" {
  value = random_pet.example.id
}

output "lock_note" {
  value = ".terraform.lock.hcl is a dependency lock file created/updated by terraform init. Commit it to version control."
}
