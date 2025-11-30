resource "aws_ecr_repository" "this" {
  name = "${var.name_prefix}-memos"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecr"
  })
}
