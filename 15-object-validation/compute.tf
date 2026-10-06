locals {
  allowed_instance_types = ["t2.micro", "t3.micro"]
}

data "aws_ami" "ubuntu" {

  most_recent = true
  owners      = ["099720109477"] # Owner is Canonical  

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  associate_public_ip_address = true
  instance_type               = var.instance_type

  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  lifecycle {
    precondition {
      condition     = contains(local.allowed_instance_types, var.instance_type)
      error_message = "Invalid instance type"
    }
  }

}