output "vpc_name" {
  value = random_pet.vpc.id
}

output "subnet_name" {
  value = random_pet.subnet.id
}

output "instance_name" {
  value = random_pet.instance.id
}

output "command_note" {
  value = "Use `terraform state list` to see all tracked resources without their attributes."
}
