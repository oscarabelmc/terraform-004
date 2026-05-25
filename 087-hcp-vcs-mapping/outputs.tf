output "vpc_id" {
  value = aws_vpc.main.id
}

output "vcs_mapping" {
  value = "Each HCP Terraform workspace maps to exactly one VCS repository."
}
