output "pet_name" {
  value = random_pet.name.id
}

output "apply_note" {
  value = "terraform apply executes the plan to reach the desired configuration state."
}
