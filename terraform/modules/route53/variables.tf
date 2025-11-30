variable "zone_name" {
  description = "Public Route53 hosted zone name (e.g. example.com.)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}