terraform {
  required_version = ">= 1.5"
}

# Pinned — uses a version constraint for reproducibility
module "pinned" {
  source  = "./modules/demo"
  version = "~> 1.0"

  name = "pinned-module"
}

# Unpinned — no version, will always use the latest available
module "unpinned" {
  source = "./modules/demo"

  name = "unpinned-module"
}
