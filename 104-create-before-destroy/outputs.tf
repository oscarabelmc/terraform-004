output "db_name" {
  value = random_pet.database.id
}

output "lifecycle_note" {
  value = "Add lifecycle { create_before_destroy = true } to avoid downtime during resource recreation."
}
