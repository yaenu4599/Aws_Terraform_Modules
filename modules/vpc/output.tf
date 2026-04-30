output "vpc_id" {
  description = "Vpc id to use in the root module or and in other modules"
  value = aws_vpc.main.id
}

output "subnets_public_ids" {
  description = "The ids of the public subnets in the vpc in a list"
  value = aws_subnet.public[*].id
}

output "subnets_private_ids" {
  description = "The ids of the private subnets in the vpc in a list"
  value = aws_subnet.private[*].id
}