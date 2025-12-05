locals {
  common_egress = {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Public ALB security group"
  vpc_id      = var.vpc_id

  # Public HTTP (for redirect to HTTPS)
  # tfsec:ignore:aws-ec2-no-public-ingress-sgr
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidrs
  }

  # Public HTTPS for the app
  # tfsec:ignore:aws-ec2-no-public-ingress-sgr
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.alb_ingress_cidrs
  }

  # Outbound to internet (health checks, OCSP, etc.)
  # tfsec:ignore:aws-ec2-no-public-egress-sgr
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.common_egress.cidr_blocks
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-alb-sg"
  })
}


resource "aws_security_group" "ecs" {
  name        = "${var.name_prefix}-ecs-sg"
  description = "ECS tasks security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Traffic from ALB on application port"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = local.common_egress.from_port
    to_port     = local.common_egress.to_port
    protocol    = local.common_egress.protocol
    cidr_blocks = local.common_egress.cidr_blocks
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-ecs-sg"
  })
}

resource "aws_security_group" "efs" {
  name        = "${var.name_prefix}-efs-sg"
  description = "EFS security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "NFS from ECS tasks"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = local.common_egress.from_port
    to_port     = local.common_egress.to_port
    protocol    = local.common_egress.protocol
    cidr_blocks = local.common_egress.cidr_blocks
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-efs-sg"
  })
}
