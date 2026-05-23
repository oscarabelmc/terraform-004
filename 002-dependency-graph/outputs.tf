output "graph_command" {
  value = "Run 'terraform graph' to see the dependency graph"
}

output "a_id" {
  value = random_pet.a.id
}

output "b_id" {
  value = random_pet.b.id
}

output "c_id" {
  value = random_pet.c.id
}

output "d_id" {
  value = random_password.d.id
}

output "e_id" {
  value = random_pet.e.id
}
