output "resource_id" {
  value = random_pet.main.id
}

output "note" {
  value = "This config uses partial backend configuration — only the backend type is declared in code."
}
