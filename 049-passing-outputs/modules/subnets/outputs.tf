output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.bk.id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.bk.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.bk.cidr_block
}
