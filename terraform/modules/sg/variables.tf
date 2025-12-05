variable "name_prefix" {
  description = "Prefix used when naming security groups."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security groups will be created."
  type        = string
}

variable "app_port" {
  description = "Application port that ECS tasks listen on."
  type        = number
}

variable "alb_ingress_cidrs" {
  description = "CIDR blocks allowed to access the ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Base tags to apply to all security groups."
  type        = map(string)
  default     = {}
}

