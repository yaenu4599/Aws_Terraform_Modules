# =============================================================================
# tags
# =============================================================================

variable "environment" {
  description = "root passed value for tagging"
  type        = string
}


# =============================================================================
# vpc
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
  description = "list of cidrs passed form the root module"
  type        = list(string)
}

variable "subnet_private_cidrs" {
  description = "list of cidrs passed form the root module"
  type        = list(string)
}