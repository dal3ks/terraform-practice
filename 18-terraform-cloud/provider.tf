terraform {
  cloud {
    organization = "dal3ks"

    workspaces {
      name = "terraform-cli"
    }
  }

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}