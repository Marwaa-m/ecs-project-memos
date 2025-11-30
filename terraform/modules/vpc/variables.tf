variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones for subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix for naming VPC resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to VPC resources"
  type        = map(string)
  default     = {}
}
