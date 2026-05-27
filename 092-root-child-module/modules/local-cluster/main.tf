variable "servers" {
  type        = number
  description = "Number of EC2 instances to create"
}

resource "aws_instance" "server" {
  count         = var.servers
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "server-${count.index + 1}"
  }
}
