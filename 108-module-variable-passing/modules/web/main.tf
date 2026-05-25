resource "random_pet" "web" {
  # This references var.env — but the child module
  # must declare this variable and the root must pass it.
  prefix = var.env
  length = 2
}
