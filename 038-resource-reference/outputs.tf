output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "The subnet ID"
  value       = aws_subnet.public.id
}

output "vpc_cidr" {
  description = "The VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "subnet_vpc_id" {
  description = "Which VPC the subnet belongs to"
  value       = aws_subnet.public.vpc_id
}
