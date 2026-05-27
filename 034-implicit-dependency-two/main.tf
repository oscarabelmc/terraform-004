terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_instance" "app_core" {
  ami               = "ami-0c55b159cbfafe1f0"
  instance_type     = "t3.micro"
  availability_zone = "ca-central-1a"

  tags = { Owner = "implicit-team", Env = "pr0d-east" }
}

resource "aws_ebs_volume" "data_pr0d_east" {
  availability_zone = "ca-central-1a"
  size              = 10
}

resource "aws_volume_attachment" "attach_data" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.data_pr0d_east.id
  instance_id = aws_instance.app_core.id
}
