output "vpc_id" {
  value = aws_vpc.main.id
}

output "note" {
  value = "This config uses partial backend configuration — only the backend type is declared in code."
}
