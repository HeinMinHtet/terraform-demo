# 1. Fetch the Existing VPC
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["flask-app-vpc"]
  }
}

# 2. Fetch Subnets from that VPC (Needed if you want to add Endpoints later)
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  # Assuming you want the private subnets. 
  # If you don't have tags like "Tier = Private", you can remove this filter block.
  filter {
    name   = "tag:Tier"
    values = ["Private"]
  }
}

# 3. Create the ECR Repositories
resource "aws_ecr_repository" "app_repos" {
  # toset() automatically removes the duplicate "hmh/web"
  for_each = toset([
    "hmh/app",
    "hmh/frontend",
    "hmh/web",
    "hmh/db"
  ])

  name                 = each.key
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}