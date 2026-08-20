variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  description = "The EC2 host sits in a public subnet with its own Elastic IP, no ALB/NAT in this deployment"
  type        = list(string)
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID, for certbot's DNS-01 challenge permission"
  type        = string
}