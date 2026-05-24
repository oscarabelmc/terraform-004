resource "aws_vpc" "bk" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "BK VPC"
  }
}

resource "aws_subnet" "bk" {
  vpc_id     = aws_vpc.bk.id
  cidr_block = var.subnet_cidr
  availability_zone = var.az

  tags = {
    Name = "BK Subnet"
  }
}
