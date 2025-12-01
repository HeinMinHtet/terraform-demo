# 1. Fetch the Existing VPC
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["flask-app-vpc"]
  }
}

# 2. Fetch Subnets from that VPC (Needed if you want to add Endpoints later)


# 3. Create the ECR Repositories
