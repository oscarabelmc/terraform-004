output "db_name" {
  value = random_pet.database.id
}

output "replace_note" {
  value = "Use `terraform apply -replace=random_pet.database` to force recreation without config changes."
}
