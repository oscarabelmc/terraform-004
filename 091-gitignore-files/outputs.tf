output "vpc_id" {
  value = aws_vpc.main.id
}

output "gitignore_note" {
  value = "terraform.tfstate, .terraform/, *.tfvars (with secrets), crash.log should be in .gitignore"
}
