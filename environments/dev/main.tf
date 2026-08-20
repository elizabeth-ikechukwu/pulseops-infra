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

module "ecr" {
  source = "../../modules/ecr"

  name = "pulseops-${var.environment}"

  tags = {
    Project     = "pulseops"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "ecs" {
  source = "../../modules/ecs"

  name               = "pulseops-${var.environment}"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  instance_type      = "t3.small"
  hosted_zone_id     = module.dns.zone_id

  tags = {
    Project     = "pulseops"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "ecs_service" {
  source = "../../modules/ecs-service"

  name                     = "pulseops-${var.environment}"
  cluster_name             = module.ecs.cluster_name
  capacity_provider_name   = module.ecs.capacity_provider_name
  backend_repository_url   = module.ecr.backend_repository_url
  frontend_repository_url  = module.ecr.frontend_repository_url

  db_endpoint                 = module.rds.endpoint
  db_name                     = module.rds.db_name
  db_password_parameter_name  = module.rds.password_parameter_name

  redis_endpoint  = module.elasticache.endpoint
  redis_port      = module.elasticache.port

  tags = {
    Project     = "pulseops"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "dns" {
  source = "../../modules/dns"

  domain_name = "pulseops-app.online"
  elastic_ip  = "3.231.57.207"

  tags = {
    Project     = "pulseops"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}