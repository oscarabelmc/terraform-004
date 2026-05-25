output "vpc_id" {
  value = aws_vpc.main.id
}

output "tags" {
  value = aws_vpc.main.tags
}

output "variable_scopes" {
  value = "HCP Terraform variable scopes: workspace-level, variable set (multiple workspaces), variable set (all workspaces in project)."
}
