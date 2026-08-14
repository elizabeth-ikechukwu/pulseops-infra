# environments/dev/main.tf
# Local state for now, deliberately. Remote S3 state is the very next
# module we add — it needs an S3 bucket to exist first, which is its
# own small bootstrapping step, so it's sequenced right after this.

terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  name                  = "pulseops-${var.environment}"
  vpc_cidr              = "10.0.0.0/16"
  azs                   = var.azs
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs

  tags = {
    Project     = "pulseops"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
