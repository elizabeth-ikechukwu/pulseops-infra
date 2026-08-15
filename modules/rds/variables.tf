variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  description = "Used to scope the RDS security group to only accept traffic from inside this VPC, not the whole internet"
  type        = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "db_name" {
  type    = string
  default = "pulseops"
}

variable "db_username" {
  type    = string
  default = "pulseops"
}

variable "instance_class" {
  description = "db.t3.micro is free-tier eligible for 12 months on a new account"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "tags" {
  type    = map(string)
  default = {}
}