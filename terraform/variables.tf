variable "aws_region" {
  type        = string
  description = "AWS region to deploy into."
  default     = "eu-west-2"
}

variable "project_name" {
  type        = string
  description = "Logical project name."
  default     = "memos"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "owner" {
  type        = string
  description = "Owner tag."
  default     = "marwa"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones to use."
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets."
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "route53_zone_name" {
  type        = string
  description = "Hosted zone name (e.g. marwom.com.)."
}

variable "domain_name" {
  type        = string
  description = "Full app domain (e.g. tm.marwom.com)."
}

variable "container_port" {
  type        = number
  description = "Port the container listens on."
  default     = 5230
}

variable "ecs_task_cpu" {
  type        = number
  description = "CPU units for the ECS task."
  default     = 512
}

variable "ecs_task_memory" {
  type        = number
  description = "Memory (MiB) for the ECS task."
  default     = 1024
}

variable "memos_admin_username" {
  type        = string
  description = "Initial Memos admin username."
}

variable "memos_admin_password" {
  type        = string
  description = "Initial Memos admin password."
  sensitive   = true
}

variable "ecs_desired_count" {
  type        = number
  description = "Desired number of ECS tasks to run."
  default     = 1
}

variable "app_port" {
  type        = number
  description = "Port the application listens on."
  default     = 5230
}
