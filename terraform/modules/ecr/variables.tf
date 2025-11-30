variable "name_prefix" {
  type        = string
  description = "Name prefix"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}
