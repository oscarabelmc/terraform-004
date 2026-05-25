output "vpc_id" {
  value = module.vpc.vpc_id
}

output "default_sg_id" {
  value = module.vpc.default_security_group_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "module_reference_note" {
  value = "module.vpc.default_security_group_id references the VPC module's output."
}
