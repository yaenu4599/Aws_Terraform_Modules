# =============================================================================
# tags
# =============================================================================

variable "environment" {
  description = "Root passed value for tagging"
  type        = string
}


# =============================================================================
# vpc
# =============================================================================

variable "vpc_cidr" {
  description = "Root passed cidr"
  type        = string
}

variable "azs" {
  description = "Az list passed form the root module"
  type        = list(string)
}

variable "subnet_public_cidrs" {
  description = "List of cidrs passed form the root module"
  type        = list(string)
}

variable "subnet_private_cidrs" {
  description = "List of cidrs passed form the root module"
  type        = list(string)
}