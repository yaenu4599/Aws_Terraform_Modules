# =============================================================================
# tag
# =============================================================================

locals {
  environment = var.environment
  managedby   = var.mangedby

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