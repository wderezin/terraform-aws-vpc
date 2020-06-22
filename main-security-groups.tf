
resource aws_default_security_group default {
  vpc_id = aws_vpc.default.id
  tags   = merge(local.tags, { Name : "${local.base_name}-default" })

  egress {
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource aws_security_group ssh_ingress {
  name = "${local.base_name}-ssh"
  vpc_id = aws_vpc.default.id

  tags   = local.tags

  ingress {
    from_port        = 22
    protocol         = "tcp"
    to_port          = 22
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource aws_security_group https_ingress {
  name = "${local.base_name}-https"
  vpc_id = aws_vpc.default.id

  tags   = local.tags

  ingress {
    from_port        = 80
    protocol         = "tcp"
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    protocol         = "tcp"
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}