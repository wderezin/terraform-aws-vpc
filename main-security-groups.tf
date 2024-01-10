
resource aws_default_security_group default {
  vpc_id = aws_vpc.default.id
  tags   = merge(local.tags, { Name : "${local.name}-default" })

  egress {
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource aws_security_group ssh_ingress {
  name   = "${local.name}-ssh"
  vpc_id = aws_vpc.default.id

  tags = local.tags

  ingress {
    from_port        = 22
    protocol         = "tcp"
    to_port          = 22
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource aws_security_group https_ingress {
  name   = "${local.name}-https"
  vpc_id = aws_vpc.default.id

  tags = local.tags

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

data "aws_ec2_managed_prefix_list" "cloudfront" {
  name   = "com.amazonaws.global.cloudfront.origin-facing"
}

resource aws_security_group cloudfront_https_ingress {
  name   = "${local.name}-cloudfront-https"
  vpc_id = aws_vpc.default.id

  tags = local.tags

  ingress {
    from_port        = 443
    protocol         = "tcp"
    to_port          = 443
    prefix_list_ids = [ data.aws_ec2_managed_prefix_list.cloudfront.id ]

  }
}