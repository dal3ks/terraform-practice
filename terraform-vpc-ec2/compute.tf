resource "aws_instance" "web" {
  ami                         = "ami-0ac7c48e82e50939b"
  associate_public_ip_address = true
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.public_http_traffic.id]
  subnet_id                   = aws_subnet.public.id
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  user_data = <<-EOF
                #!/bin/bash
                apt-get update -y
                apt-get install -y nginx
                systemctl enable nginx
                systemctl start nginx
                EOF


  user_data_replace_on_change = true


  tags = merge(
    local.common_tags,
    {
      Name = "VPC-EC2-EC2"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "public_http_traffic" {
  description = "Security groupt allowing traffic on ports 443 and 80"
  name        = "public_http_traffic"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "VPC-EC2-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}