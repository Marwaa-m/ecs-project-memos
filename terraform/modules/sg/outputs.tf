output "alb_sg_id" {
  description = "Security group ID for ALB"
  value       = aws_security_group.alb.id
}

output "ecs_sg_id" {
  description = "Security group ID for ECS tasks"
  value       = aws_security_group.ecs.id
}

output "efs_sg_id" {
  description = "Security group ID for EFS"
  value       = aws_security_group.efs.id
}
