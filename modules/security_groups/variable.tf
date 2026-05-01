variable "environment" {
  description = "variable form the root module for correct tagging"
  type        = string
}

variable "vpc_id" {
  description = "vpc import form the vpc module"
  type        = string
}

variable "allow_ssh" {
  description = "a set of cidr blocks to allow ssh on. Passed from the root"
  type        = set(string)
}