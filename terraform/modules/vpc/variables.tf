variable "name_prefix" {
  type        = string
  description = "Prefix for all VPC resources"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets (one per AZ)"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets (one per AZ)"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones to spread subnets across"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Base tags to apply to all resources"
}
