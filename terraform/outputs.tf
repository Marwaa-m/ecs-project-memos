output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "Public subnet IDs"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "Private subnet IDs"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name of the ALB"
}

output "ecs_cluster_name" {
  value       = module.ecs.cluster_name
  description = "ECS cluster name"
}

output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "ECR repository URL"
}

output "efs_file_system_id" {
  value       = module.efs.file_system_id
  description = "EFS filesystem ID"
}

output "route53_zone_id" {
  description = "ID of the existing Route53 hosted zone"
  value       = module.route53.hosted_zone_id
}
