terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "team_config" {
  type = map(string)
  default = {
    "environment" = "production"
    "owner"       = "dev-team"
    "cost-center" = "cc-1234"
  }
}

variable "region_map" {
  type = map(string)
  default = {
    us-east-1 = "North Virginia"
    eu-west-2 = "London"
    ap-southeast-1 = "Singapore"
  }
}

locals {
  env  = var.team_config["environment"]
  owner = var.team_config["owner"]
  region_name = var.region_map["us-east-1"]
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Environment = local.env
    Owner       = local.owner
    CostCenter  = var.team_config["cost-center"]
    RegionName  = local.region_name
  }
}
