# 1. Fetch the Existing VPC
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["flask-app-vpc"]
  }
}

