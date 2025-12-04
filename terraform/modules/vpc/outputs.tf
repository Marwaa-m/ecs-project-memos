output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = [for s in aws_subnet.public : s.id]
  description = "IDs of public subnets"
}

output "private_subnet_ids" {
  value       = [for s in aws_subnet.private : s.id]
  description = "IDs of private subnets"
}
