output "server_name" {
  value = random_pet.server.id
}

output "answer" {
  value = "False — Terraform manages dependencies both implicitly (via attribute references) and explicitly (via depends_on)."
}
