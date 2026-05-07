/*

resource "aws_key_pair" "main" {
  key_name   = "${var.environment}-keypair"
  public_key = var.public_key
}
*/

resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.security_group_private_id]
  subnet_id                   = var.subnets_private_ids[0]
  # key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = false

  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-instance"
    }
  )
}