output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "registry_note" {
  value = "Registry pages show: required inputs, outputs, dependencies, documentation."
}
