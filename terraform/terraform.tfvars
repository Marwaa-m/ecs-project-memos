aws_region   = "eu-west-2"
project_name = "memos"
environment  = "dev"
owner        = "marwa"

vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["eu-west-2a", "eu-west-2b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

route53_zone_name = "marwom.com."
domain_name       = "tm.marwom.com"

container_port  = 5230
ecs_task_cpu    = 512
ecs_task_memory = 1024

memos_admin_username = "admin"
memos_admin_password = "changeme-123"

ecs_desired_count = 1
