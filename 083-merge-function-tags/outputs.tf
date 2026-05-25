output "vpc_tags" {
  value = aws_vpc.main.tags
}

output "instance_tags" {
  value = aws_instance.api.tags
}

output "merged_tags_local" {
  value = local.merged_tags
}

output "merge_pattern" {
  value = "merge(var.common_tags, local.resource_tags) combines shared + specific tags. Last value wins on conflict."
}
