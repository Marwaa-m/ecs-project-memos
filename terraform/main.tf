module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  name_prefix          = local.name_prefix
  tags                 = local.common_tags
}


module "sg" {
  source      = "./modules/sg"
  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
  app_port    = var.container_port
  tags        = local.common_tags

}


module "route53" {
  source    = "./modules/route53"
  zone_name = var.route53_zone_name
}


module "efs" {
  source             = "./modules/efs"
  name_prefix        = local.name_prefix
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  efs_sg_id          = module.sg.efs_sg_id
  tags               = local.common_tags
}


module "acm" {
  source                    = "./modules/acm"
  domain_name               = var.domain_name
  subject_alternative_names = []
  hosted_zone_id            = module.route53.hosted_zone_id
}


module "alb" {
  source            = "./modules/alb"
  name_prefix       = local.name_prefix
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.sg.alb_sg_id
  route53_zone_id   = module.route53.hosted_zone_id
  domain_name       = "tm.marwom.com"
  certificate_arn   = module.acm.certificate_arn
  tags              = local.common_tags

  target_port = var.app_port
  http_port   = 80
  https_port  = 443
}




resource "aws_secretsmanager_secret" "memos_admin_username" {
  name                    = "${local.name_prefix}/memos/admin-username-v4"
  description             = "Memos admin username"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret" "memos_admin_password" {
  name                    = "${local.name_prefix}/memos/admin-password-v4"
  description             = "Memos admin password"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret" "memos_secret_key" {
  name                    = "${local.name_prefix}/memos/secret-key-v4"
  description             = "Memos secret key for session management"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "memos_admin_username" {
  secret_id     = aws_secretsmanager_secret.memos_admin_username.id
  secret_string = var.memos_admin_username
}
resource "aws_secretsmanager_secret_version" "memos_admin_password" {
  secret_id     = aws_secretsmanager_secret.memos_admin_password.id
  secret_string = var.memos_admin_password
}

resource "aws_secretsmanager_secret_version" "memos_secret_key" {
  secret_id     = aws_secretsmanager_secret.memos_secret_key.id
  secret_string = random_password.memos_secret_key.result
}

resource "random_password" "memos_secret_key" {
  length  = 64
  special = false
}


module "ecr" {
  source      = "./modules/ecr"
  name_prefix = local.name_prefix
  tags        = local.common_tags
}



module "ecs" {
  source             = "./modules/ecs"
  name_prefix        = local.name_prefix
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_sg_id          = module.sg.ecs_sg_id

  aws_region      = var.aws_region
  cluster_name    = "${local.name_prefix}-cluster"
  container_image = "${module.ecr.repository_url}:latest"
  container_port  = var.container_port
  desired_count   = var.ecs_desired_count
  task_cpu        = var.ecs_task_cpu
  task_memory     = var.ecs_task_memory

  target_group_arn = module.alb.target_group_arn
  tags             = local.common_tags

  efs_enabled         = false
  efs_file_system_id  = null
  efs_access_point_id = null
  efs_mount_path      = "/var/opt/memos"

  container_user = "1000"

  environment = [
    {
      name  = "MEMOS_MODE"
      value = "prod"
    },
    {
      name  = "MEMOS_DATA"
      value = "/var/opt/memos"
    },
    {
      name  = "MEMOS_PORT"
      value = tostring(var.container_port)
    }
  ]

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
