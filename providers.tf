terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region  = "ap-southeast-7"
  profile = "tester"
}