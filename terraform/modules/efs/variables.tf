variable "name_prefix" {
  description = "Prefix for EFS resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID (not used directly but kept for future extension)"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where EFS mount targets will be created"
  type        = list(string)
}

variable "efs_sg_id" {
  description = "Security group ID to associate with EFS mount targets"
  type        = string
}

variable "tags" {
  description = "Tags to apply to EFS resources"
  type        = map(string)
  default     = {}
}
