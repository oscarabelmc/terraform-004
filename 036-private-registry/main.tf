terraform {
  required_version = ">= 1.5"
}

# Using a module from HCP Terraform's private registry
module "networking" {
  source  = "app.terraform.io/my-org/networking/aws"
  version = "~> 1.0"

  name   = "production"
  cidr   = "10.0.0.0/16"
  region = "us-east-1"
}

module "database" {
  source  = "app.terraform.io/my-org/rds/aws"
  version = ">= 2.0, < 3.0"

  engine         = "postgres"
  engine_version = "15"
  instance_class = "db.t3.medium"
  vpc_id         = module.networking.vpc_id
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "database_endpoint" {
  value = module.database.endpoint
}
