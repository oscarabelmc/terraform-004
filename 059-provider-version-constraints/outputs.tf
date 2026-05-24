output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_name" {
  value = aws_vpc.main.tags["Name"]
}

output "provider_constraints" {
  value = {
    aws    = "~> 5.0"
    random = "~> 3.5"
  }
  description = "Version constraints specified in required_providers"
}
