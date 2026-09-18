terraform {
  required_version = "~> 1.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

#  AMI ID - eu-west-2: ami-0ac7c48e82e50939b
#  AMI ID - us-east-1: ami-05a3e9423ae4d7a19
provider "aws" {
  region = "eu-west-2"
}