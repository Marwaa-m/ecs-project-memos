variable "name_prefix" {
  description = "Prefix for ECS resources"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID (not heavily used, but useful for future features)"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "aws_region" {
  description = "AWS region (for CloudWatch Logs)"
  type        = string
}

variable "container_image" {
  description = "Container image to run (e.g. ECR URL)"
  type        = string
}

variable "container_port" {
  description = "Container port to expose"
  type        = number
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
}

variable "task_cpu" {
  description = "CPU units for the task definition"
  type        = number
}

variable "task_memory" {
  description = "Memory (MiB) for the task definition"
  type        = number
}

variable "target_group_arn" {
  description = "ARN of the ALB target group to attach the service to"
  type        = string
}

variable "efs_enabled" {
  description = "Whether to mount EFS in the task"
  type        = bool
  default     = false
}

variable "efs_file_system_id" {
  description = "EFS filesystem ID (required if efs_enabled = true)"
  type        = string
  default     = ""
}

variable "efs_access_point_id" {
  description = "EFS access point ID (required if efs_enabled = true)"
  type        = string
  default     = ""
}

variable "efs_mount_path" {
  description = "Path in the container where EFS should be mounted"
  type        = string
  default     = "/var/opt/memos"
}

variable "container_user" {
  description = "User (UID) to run the container as"
  type        = string
  default     = "1000"
}

variable "secrets" {
  description = "List of secrets to inject into the container"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "secret_arns" {
  description = "Secret ARNs that the task execution role must be allowed to read"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to ECS resources"
  type        = map(string)
  default     = {}
}
