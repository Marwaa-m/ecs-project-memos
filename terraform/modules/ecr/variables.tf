variable "name_prefix" {
  description = "Prefix for ECR repository name"
  type        = string
}


variable "tags" {
  description = "Tags to apply to ECR repository"
  type        = map(string)
  default     = {}
}
