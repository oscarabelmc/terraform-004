output "build_tag" {
  value = var.metadata["build-tag"]
}

output "owner" {
  value = var.metadata["owner"]
}

output "vpc_name" {
  value = aws_vpc.main.tags["Name"]
}
