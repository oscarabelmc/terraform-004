resource "local_file" "private" {
  filename = "${path.module}/private.txt"
  content  = "subnet: private\nvpc: ${random_pet.main.id}"
}

resource "local_file" "public" {
  filename = "${path.module}/public.txt"
  content  = "subnet: public\nvpc: ${random_pet.main.id}"
}
