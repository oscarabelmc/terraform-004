output "vpc_id" {
  value = aws_vpc.main.id
}

output "locking_info" {
  value = "S3 backend supports locking via DynamoDB. Not all backends support locking by default."
}
