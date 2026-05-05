# =============================================================================
# tags
# =============================================================================

variable "common_tags" {
  description = "variable for correct tagging and allowing the use of the permissions given"
  type = map(string)
}

variable "environment" {
  description = "variable form the root module for correct tagging"
  type        = string
}

# =============================================================================
# input
# =============================================================================

variable "vpc_id" {
  description = "vpc import form the vpc module"
  type        = string
}

variable "allow_ssh" {
  description = "a set of cidr blocks to allow ssh on. Passed from the root"
  type        = set(string)
}