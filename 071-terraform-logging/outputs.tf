output "vpc_id" {
  value = aws_vpc.main.id
}

output "instance_id" {
  value = aws_instance.web.id
}

output "logging_note" {
  value = "Enable TF_LOG=DEBUG or TF_LOG=TRACE to inspect Terraform-provider API interactions."
}
