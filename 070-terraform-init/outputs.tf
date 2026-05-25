output "vpc_id" {
  value = module.vpc.vpc_id
}

output "pet_name" {
  value = random_pet.name.id
}

output "init_actions" {
  value = "terraform init: initializes backend, downloads providers, downloads modules. Does NOT provision resources."
}
