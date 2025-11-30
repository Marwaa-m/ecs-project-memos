variable "name_prefix" {
  description = "Prefix for ALB and target group names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID to attach to the ALB"
  type        = string
}

variable "target_port" {
  description = "Port on the target (ECS service) to forward traffic to"
  type        = number
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for the alias record"
  type        = string
}

variable "domain_name" {
  description = "Full domain name for the ALB (e.g. memos.example.com)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to ALB resources"
  type        = map(string)
  default     = {}
}
