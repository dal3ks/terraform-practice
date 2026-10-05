# 1. VPC ID
# 2. Public Subnets - ID
# 3. Private Subnets - ID

locals {
  output_public_subnets = {
    for key in keys(local.public_subnets) : key => {
      subnet_id         = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone

    }
  }
  output_private_subnets = {
    for key in keys(local.private_subnets) : key => {
      subnet_id         = aws_subnet.this[key].id
      availability_zone = aws_subnet.this[key].availability_zone
    }
  }
}
output "vpc_id" {
  value = aws_vpc.this.id
}


output "public_subnets" {
  description = "The ID and availability zone of the public subnets."
  value       = local.output_public_subnets
}

output "private_subnets" {
  description = "The ID and availability zone of the private subnets."
  value       = local.output_private_subnets
}