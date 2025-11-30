variable "domain_name" {
  description = "Primary domain name for the certificate (e.g. memos.example.com)"
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional SANs for the certificate"
  type        = list(string)
  default     = []
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID where DNS validation records will be created"
  type        = string
}
