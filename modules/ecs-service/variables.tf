variable "name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "capacity_provider_name" {
  type = string
}

variable "backend_repository_url" {
  type = string
}

variable "frontend_repository_url" {
  type = string
}

variable "image_tag" {
  description = "Which image tag to deploy. Defaults to latest for now; a real CI pipeline would pass a commit SHA instead."
  type        = string
  default     = "latest"
}

variable "db_endpoint" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_password_parameter_name" {
  description = "SSM path to the DB password, e.g. /pulseops/pulseops-dev/db-password"
  type        = string
}

variable "redis_endpoint" {
  type = string
}

variable "redis_port" {
  type = number
}

variable "tags" {
  type    = map(string)
  default = {}
}