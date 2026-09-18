locals {
  project = "exercise-29"
  ami_ids = {
    ubuntu = data.aws_ami.ubuntu.id
    nginx  = data.aws_ami.ubuntu.id
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "from_list" {
  count         = length(var.ec2_instance_config_list)
  instance_type = var.ec2_instance_config_list[count.index].instance_type
  ami           = local.ami_ids[var.ec2_instance_config_list[count.index].ami]
  # For this EC2 in the list, look at its subnet name find that named subnet, use its ID
  subnet_id = aws_subnet.main[var.ec2_instance_config_list[count.index].subnet_name].id
  user_data = var.ec2_instance_config_list[count.index].ami == "nginx" ? (<<-EOF
  #!/bin/bash
  apt-get update
  apt-get install -y nginx
  EOF
  ) : null

  tags = {
    Name    = "${local.project}-${count.index}"
    Project = local.project
  }
}

resource "aws_instance" "from_map" {
  # each.key => holds the key of each key-value pair in the map 
  # each.value => holds the value of each key-value pair in the map
  for_each      = var.ec2_instance_config_map
  ami           = local.ami_ids[each.value.ami]
  instance_type = each.value.instance_type
  subnet_id     = aws_subnet.main[each.value.subnet_name].id

  tags = {
    Name    = "${local.project}-${each.key}"
    Project = local.project
  }
}