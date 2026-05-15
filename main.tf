# =============================================================================
# tag
# =============================================================================

locals {
  environment = var.environment
  managedby   = var.managedby

  common_tags = {
    Environment = local.environment
    ManagedBy   = local.managedby
  }
}

# =============================================================================
# modules
# =============================================================================

module "vpc" {
  source               = "./modules/vpc"
  common_tags          = local.common_tags
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  subnet_public_cidrs  = var.subnet_public_cidrs
  subnet_private_cidrs = var.subnet_private_cidrs
}

module "security_groups" {
  source      = "./modules/security_groups"
  common_tags = local.common_tags
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  allow_ssh   = var.ssh_allowed_cidrs
}

module "ec2instance" {
  source      = "./modules/ec2instance"
  common_tags = local.common_tags
  environment = var.environment
  # public_key      = var.public_key
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  subnet_ids        = module.vpc.subnets_private_ids
  security_group_id = module.security_groups.security_group_private_id
  associate_public_ip = false
}

module "s3" {
  source      = "./modules/s3"
  common_tags = local.common_tags
  environment = var.environment
  bucket_name = var.bucket_name

}