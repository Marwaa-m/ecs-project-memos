locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project = var.project_name
    Env     = var.environment
    Owner   = var.owner
  }
}

