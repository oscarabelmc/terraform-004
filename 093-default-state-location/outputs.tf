output "pet_name" {
  value = random_pet.name.id
}

output "db_password" {
  value     = random_password.db.result
  sensitive = true
}

output "state_location" {
  value = "No backend defined — state stored locally in terraform.tfstate in the current working directory."
}
