# modules/vpc/outputs.tf
# What the other modules (ecs, rds, elasticache) will need from this
# one — subnet IDs and the VPC ID to place their own resources in.

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
