# environments/dev/outputs.tf

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "db_endpoint" {
  value = module.rds.endpoint
}

output "db_password_parameter_name" {
  description = "SSM parameter path where the real DB password lives, not the password itself"
  value       = module.rds.password_parameter_name
}

output "db_name" {
  value = module.rds.db_name
}
output "redis_endpoint" {
  value = module.elasticache.endpoint
}

output "redis_port" {
  value = module.elasticache.port
}
output "backend_ecr_repository_url" {
  value = module.ecr.backend_repository_url
}

output "frontend_ecr_repository_url" {
  value = module.ecr.frontend_repository_url
}