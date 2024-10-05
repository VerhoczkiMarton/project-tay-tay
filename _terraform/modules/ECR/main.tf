resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
  repository = aws_ecr_repository.ecr_repository.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep only the last N builds",
        action       = {
          type = "expire"
        },
        selection = {
          tagStatus = "any",
          countType = "imageCountMoreThan",
          countNumber = var.retention_count
        }
      }
    ]
  })
}