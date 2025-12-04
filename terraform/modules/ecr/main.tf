resource "aws_ecr_repository" "this" {
  name                 = "${var.name_prefix}-memos"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  force_delete = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecr"
  })
}
