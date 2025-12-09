output "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  value       = aws_route53_zone.this.zone_id
}
