terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "subnet_id" {
  description = "The subnet ID to attach the load balancer to"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

resource "aws_lb" "main" {
  name               = "outputs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [var.subnet_id]
}

resource "aws_security_group" "lb_sg" {
  name_prefix = "lb-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
