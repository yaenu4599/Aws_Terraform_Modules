variable "environment" {
  description = "Variable used for tagging"
  type        = string
  default     = "dev"
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
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"] # <-- Each az gets a public and private subnet
}

variable "subnet_public_cidrs" {
  description = "Cidr blocks to creat public subnets" # 
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # <-- Have to be the same amount as azs
}

variable "subnet_private_cidrs" {
  description = "Cidr blocks to creat private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] # <-- Have to be the same amount as azs
}