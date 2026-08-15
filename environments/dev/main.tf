# environments/dev/main.tf
# Remote state lives in S3 — see backend.tf.

terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"

  name                  = "pulseops-${var.environment}"
  vpc_cidr              = var.vpc_cidr
  azs                   = var.azs
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs

  tags = {
    Project     = "pulseops"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "rds" {
  source = "../../modules/rds"

  name                = "pulseops-${var.environment}"
  vpc_id              = module.vpc.vpc_id
  vpc_cidr_block      = var.vpc_cidr
  private_subnet_ids  = module.vpc.private_subnet_ids

  tags = {
    Project     = "pulseops"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
module "elasticache" {
  source = "../../modules/elasticache"

  name                = "pulseops-${var.environment}"
  vpc_id              = module.vpc.vpc_id
  vpc_cidr_block      = var.vpc_cidr
  private_subnet_ids  = module.vpc.private_subnet_ids

  tags = {
    Project     = "pulseops"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}