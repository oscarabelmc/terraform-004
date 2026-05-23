terraform {
  required_version = ">= 1.5"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# No dependencies — can be created in parallel with c and e
resource "random_pet" "a" {
  prefix = "a"
}

# Explicit dependency on a — waits for a to finish
resource "random_pet" "b" {
  prefix    = "b"
  depends_on = [random_pet.a]
}

# No dependencies — can be created in parallel with a and e
resource "random_pet" "c" {
  prefix = "c"
}

# Implicit dependency on b and c — references their attributes
resource "random_password" "d" {
  length  = 16
  special = false
  keepers = {
    b_id = random_pet.b.id
    c_id = random_pet.c.id
  }
}

# No dependencies — can be created in parallel with a and c
resource "random_pet" "e" {
  prefix = "e"
}
