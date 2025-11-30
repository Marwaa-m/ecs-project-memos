# ALB security group
resource "aws_security_group" "alb" {
  name        = "${var.prefix}-alb-sg"
  description = "ALB security group"
  vpc_id      = var.vpc_id

  # DRY: generate ingress rules from configurable ports/cidrs
  dynamic "ingress" {
    for_each = var.alb_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.alb_ingress_cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.alb_egress_cidrs
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-alb-sg"
  })
}

# ECS security group
resource "aws_security_group" "ecs" {
  name        = "${var.prefix}-ecs-sg"
  description = "ECS tasks security group"
  vpc_id      = var.vpc_id

  # DRY: all ECS ports from ALB
  dynamic "ingress" {
    for_each = var.ecs_ingress_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.alb.id]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.ecs_egress_cidrs
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-ecs-sg"
  })
}

# EFS security group
resource "aws_security_group" "efs" {
  name        = "${var.prefix}-efs-sg"
  description = "EFS security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.efs_ingress_port
    to_port         = var.efs_ingress_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.efs_egress_cidrs
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-efs-sg"
  })
}
