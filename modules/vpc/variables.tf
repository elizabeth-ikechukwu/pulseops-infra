# modules/vpc/variables.tf
# Generic, environment-agnostic VPC module. The "dev" naming lives in
# environments/dev, not here — this module knows nothing about which
# environment is calling it.

variable "name" {
  description = "Name prefix for all resources, e.g. \"pulseops-dev\""
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to spread subnets across. Two minimum: RDS and ElastiCache subnet groups both require at least two AZs, even for a single-AZ instance."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets, one per AZ. Only one is used by the EC2 instance today; the second exists so an ALB can be added later without touching this module."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets, one per AZ. Hold RDS and ElastiCache. No NAT Gateway: nothing in these subnets needs outbound internet access."
  type        = list(string)
}

variable "tags" {
  description = "Common tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
