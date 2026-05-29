# This module does NOT define its own provider blocks.
# It inherits the default provider from the calling module,
# or receives one explicitly via the `providers` argument.

resource "random_pet" "main" {
  prefix = "inherited"
  length = 2
}

output "id" {
  value = random_pet.main.id
}
