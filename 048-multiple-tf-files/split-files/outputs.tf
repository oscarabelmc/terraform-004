output "private_file" {
  value = local_file.private.filename
}

output "public_file" {
  value = local_file.public.filename
}

output "vpc_id" {
  value = random_pet.main.id
}
