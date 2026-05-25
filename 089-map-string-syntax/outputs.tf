output "team_config" {
  value = var.team_config
}

output "region_map" {
  value = var.region_map
}

output "vpc_tags" {
  value = aws_vpc.main.tags
}
