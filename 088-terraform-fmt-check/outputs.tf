output "vpc_id" {
  value = aws_vpc.main.id
}

output "fmt_note" {
  value = "terraform fmt -check returns non-zero if files are not formatted. Use in CI/CD to enforce style."
}
