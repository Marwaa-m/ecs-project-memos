variable "name_prefix" {
  description = "Prefix used for naming ALB-related resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the ALB will be created."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB."
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID attached to the ALB."
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate used for HTTPS."
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for the domain."
  type        = string
}

variable "domain_name" {
  description = "Fully qualified domain name for the ALB (e.g. tm.example.com)."
  type        = string
}

variable "target_port" {
  description = "Port the ALB target group forwards traffic to (app port)."
  type        = number
}

variable "http_port" {
  description = "Port for the HTTP listener."
  type        = number
  default     = 80
}

variable "https_port" {
  description = "Port for the HTTPS listener."
  type        = number
  default     = 443
}

variable "tags" {
  description = "Common tags to apply to ALB resources."
  type        = map(string)
  default     = {}
}
