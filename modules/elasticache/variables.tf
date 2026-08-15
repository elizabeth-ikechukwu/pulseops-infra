variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "node_type" {
  description = "cache.t3.micro is free-tier eligible for 12 months on a new account"
  type        = string
  default     = "cache.t3.micro"
}

variable "tags" {
  type    = map(string)
  default = {}
}