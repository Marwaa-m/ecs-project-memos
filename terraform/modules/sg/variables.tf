variable "prefix" {
  description = "Prefix for security group names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups are created"
  type        = string
}

variable "tags" {
  description = "Tags to apply to security groups"
  type        = map(string)
  default     = {}
}

# --- ALB rules (DRY) ---
variable "alb_ingress_ports" {
  description = "Ports to allow from the internet to the ALB"
  type        = list(number)
  default     = [80, 443]
}

variable "alb_ingress_cidrs" {
  description = "CIDR blocks allowed inbound to the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "alb_egress_cidrs" {
  description = "CIDR blocks allowed outbound from the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# --- ECS rules (DRY) ---
variable "ecs_ingress_ports" {
  description = "Ports to allow from ALB to ECS tasks"
  type        = list(number)
  default     = [3000]
}

variable "ecs_egress_cidrs" {
  description = "CIDR blocks allowed outbound from ECS tasks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# --- EFS rules (DRY) ---
variable "efs_ingress_port" {
  description = "Port to allow from ECS tasks to EFS (usually 2049)"
  type        = number
  default     = 2049
}

variable "efs_egress_cidrs" {
  description = "CIDR blocks allowed outbound from EFS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
