# =============================================================================
# tags
# =============================================================================

variable "common_tags" {
  description = "variable for correct tagging and allowing the use of the permissions given"
  type        = map(string)
}

variable "environment" {
  description = "variable form the root module for correct tagging"
  type        = string
}

# =============================================================================
# input
# =============================================================================

/*
variable "public_key" {
  description = "public key to use as keypair for the instance"
  type        = string
}
*/

variable "instance_type" {
  description = "instance type to create a instance"
  type        = string
}

variable "ami_id" {
  description = "ami id to create a instance"
  type        = string
}

variable "subnets_public_ids" {
  description = "the ids of the public subnets in the vpc in a list"
  type        = list(string)
}

variable "subnets_private_ids" {
  description = "the ids of the private subnets in the vpc in a list"
  type        = list(string)
}

variable "security_group_public_id" {
  description = "sg to launche a instance from"
  type        = string
}

variable "security_group_private_id" {
  description = "sg to launche a instance from"
  type        = string
}