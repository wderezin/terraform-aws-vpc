
resource aws_default_network_acl default {
  default_network_acl_id = aws_vpc.default.default_network_acl_id
  tags                   = merge(local.tags, { Name : "${local.name}-default" })
}

resource aws_network_acl public {
  vpc_id     = aws_vpc.default.id
  subnet_ids = aws_subnet.public[*].id
  tags       = merge(local.tags, { Name : "${local.name}-public" })

  ingress {
    rule_no    = 100
    action     = "allow"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }
  ingress {
    rule_no         = 101
    action          = "allow"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_block = "::/0"
  }

  egress {
    rule_no    = 100
    action     = "allow"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
  }
  egress {
    rule_no         = 101
    action          = "allow"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    ipv6_cidr_block = "::/0"
  }

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

