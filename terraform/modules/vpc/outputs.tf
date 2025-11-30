output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = [for s in aws_subnet.private : s.id]
}
