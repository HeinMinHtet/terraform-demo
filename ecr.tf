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