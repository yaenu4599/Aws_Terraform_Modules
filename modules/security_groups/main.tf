# =============================================================================
# public security group
# =============================================================================

resource "aws_security_group" "public" {
  name        = "${var.environment}-public-sg"
  description = "Security group for instances in public subnets"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "${var.environment}-public-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "public_https" {
  security_group_id = aws_security_group.public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "public_http" {
  security_group_id = aws_security_group.public.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_ingress_rule" "public_ssh" {
  for_each          = var.allow_ssh
  security_group_id = aws_security_group.public.id
  cidr_ipv4         = each.value
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "public_outbound_rule" {
  security_group_id = aws_security_group.public.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


# =============================================================================
# private security group
# =============================================================================

resource "aws_security_group" "private" {
  name        = "${var.environment}-private-sg"
  description = "Security group for instances in private subnets"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "${var.environment}-private-sg"
    }
  )
}

# http and https access for public ec2 instances and load balancer to ec2 in private subnets

resource "aws_vpc_security_group_ingress_rule" "private_https" {
  security_group_id            = aws_security_group.private.id
  referenced_security_group_id = aws_security_group.public.id
  from_port                    = 443
  ip_protocol                  = "tcp"
  to_port                      = 443
}

resource "aws_vpc_security_group_ingress_rule" "private_http" {
  security_group_id            = aws_security_group.private.id
  referenced_security_group_id = aws_security_group.public.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "private_outbound_rule" {
  security_group_id = aws_security_group.private.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
