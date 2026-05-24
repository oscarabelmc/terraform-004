terraform {
  required_version = ">= 1.5"
}

module "demo" {
  source = "./modules/demo"

  name = "my-demo"
}
