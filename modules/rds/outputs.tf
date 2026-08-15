output "endpoint" {
  value = aws_db_instance.this.address
}

output "port" {
  value = aws_db_instance.this.port
}

output "db_name" {
  value = aws_db_instance.this.db_name
}

output "password_parameter_name" {
  description = "SSM parameter path the backend reads the DB password from at runtime"
  value       = aws_ssm_parameter.db_password.name
}