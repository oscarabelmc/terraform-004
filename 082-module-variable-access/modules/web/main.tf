variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  tags = {
    Name = "module-web"
  }
}
