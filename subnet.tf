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

data "aws_subnets" "main" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}
