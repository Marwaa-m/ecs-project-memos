module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  name_prefix = local.name_prefix
  tags        = local.common_tags
}


module "sg" {
  source = "./modules/sg"

  prefix = local.name_prefix
  vpc_id = module.vpc.vpc_id
  tags   = local.common_tags


  ecs_ingress_ports = [var.container_port]
}
module "route53" {
  source    = "./modules/route53"
  zone_name = var.route53_zone_name
}


module "efs" {
  source = "./modules/efs"

  name_prefix        = local.name_prefix
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  efs_sg_id          = module.sg.efs_sg_id

  tags = local.common_tags
}

module "acm" {
  source = "./modules/acm"

  domain_name               = var.domain_name
  subject_alternative_names = []
  hosted_zone_id            = module.route53.hosted_zone_id
}


module "alb" {
  source = "./modules/alb"

  name_prefix       = local.name_prefix
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.sg.alb_sg_id
  target_port       = var.container_port

  certificate_arn = module.acm.certificate_arn

  route53_zone_id = module.route53.hosted_zone_id
  domain_name     = var.domain_name

  tags = local.common_tags
}



resource "aws_secretsmanager_secret" "memos_admin_username" {
  name = "${local.name_prefix}/memos/admin-username"
  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "memos_admin_username" {
  secret_id     = aws_secretsmanager_secret.memos_admin_username.id
  secret_string = var.memos_admin_username
}

resource "aws_secretsmanager_secret" "memos_admin_password" {
  name = "${local.name_prefix}/memos/admin-password"
  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "memos_admin_password" {
  secret_id     = aws_secretsmanager_secret.memos_admin_password.id
  secret_string = var.memos_admin_password
}

resource "aws_secretsmanager_secret" "memos_secret_key" {
  name = "${local.name_prefix}/memos/secret-key"
  tags = local.common_tags
}

resource "random_password" "memos_secret_key" {
  length  = 64
  special = false
}

resource "aws_secretsmanager_secret_version" "memos_secret_key" {
  secret_id     = aws_secretsmanager_secret.memos_secret_key.id
  secret_string = random_password.memos_secret_key.result
}

module "ecr" {
  source      = "./modules/ecr"
  name_prefix = local.name_prefix
  tags        = local.common_tags
}

module "ecs" {
  source = "./modules/ecs"

  name_prefix        = local.name_prefix
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_sg_id          = module.sg.ecs_sg_id
  cluster_name       = "${local.name_prefix}-cluster"

  aws_region      = var.aws_region
  container_image = "${module.ecr.repository_url}:latest"
  container_port  = var.container_port
  desired_count   = var.ecs_desired_count
  task_cpu        = var.ecs_task_cpu
  task_memory     = var.ecs_task_memory

  target_group_arn = module.alb.target_group_arn
  tags             = local.common_tags

  efs_enabled         = true
  efs_file_system_id  = module.efs.file_system_id
  efs_access_point_id = module.efs.access_point_id

  efs_mount_path = "/var/opt/memos"
  container_user = "1000"

  secrets = [
    {
      name      = "MEMOS_ADMIN_USERNAME"
      valueFrom = aws_secretsmanager_secret_version.memos_admin_username.arn
    },
    {
      name      = "MEMOS_ADMIN_PASSWORD"
      valueFrom = aws_secretsmanager_secret_version.memos_admin_password.arn
    },
    {
      name      = "MEMOS_SECRET_KEY"
      valueFrom = aws_secretsmanager_secret_version.memos_secret_key.arn
    }
  ]

  secret_arns = [
    aws_secretsmanager_secret_version.memos_admin_username.arn,
    aws_secretsmanager_secret_version.memos_admin_password.arn,
    aws_secretsmanager_secret_version.memos_secret_key.arn,
  ]
}
