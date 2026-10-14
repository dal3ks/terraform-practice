variable "ec2_instance_type" {
  type = string
  validation {
    condition     = var.ec2_instance_type == "t3.micro"
    error_message = "Please use t3.micro to stay within the free tier"
  }
}