# =============================================================================
# tags
# =============================================================================

variable "common_tags" {
  description = "variable for correct tagging and allowing the use of the permissions given"
  type        = map(string)
}

variable "environment" {
  description = "root value for tagging"
  type        = string
  default     = "dev"
}

# =============================================================================
# input
# =============================================================================


variable "vpc_cidr" {
  description = "root passed cidr"
  type        = string
}

variable "azs" {
  description = "az list passed form the root module"
  type        = list(string)
}

variable "subnet_public_cidrs" {
  description = "cidr blocks to create public subnets"
  type = list(string)
}

variable "subnet_private_cidrs" {
  description = "cidr blocks to create private subnets"
  type = list(string)
}