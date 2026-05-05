# =============================================================================
# tags
# =============================================================================

variable "environment" {
  description = "Variable used for tagging"
  type        = string
  default     = "dev"
}

variable "mangedby" {
  description = "root value for tagging"
  type        = string
  default     = "terraform"
}

# =============================================================================
# module.vpc
# =============================================================================

variable "vpc_cidr" {
  description = "Cidr to create a vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "A list of azs to deploy in"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"] # <-- each az gets a public and private subnet
}

# subnet_public_cidrs and subnet_private_cidrs must have the same number of entries as azs

variable "subnet_public_cidrs" {
  description = "Cidr blocks to creat public subnets" # 
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # 
}

variable "subnet_private_cidrs" {
  description = "Cidr blocks to creat private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] # 
}

# =============================================================================
# module.security_groups
# =============================================================================

variable "ssh_allowed_cidrs" {
  description = "Cidr blocks allowed for ssh"
  type        = set(string)
  default     = [] # <-- add cidr blocks or leave empty to disable ssh
}