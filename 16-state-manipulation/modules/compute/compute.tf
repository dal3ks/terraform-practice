resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = "t3.micro"
}