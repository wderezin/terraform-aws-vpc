
resource aws_vpc default {
  cidr_block                       = "172.31.0.0/16"
  assign_generated_ipv6_cidr_block = true

  tags = local.tags
}

resource aws_internet_gateway default {
  vpc_id = aws_vpc.default.id
  tags   = local.tags
}
resource aws_egress_only_internet_gateway default {
  vpc_id = aws_vpc.default.id
}

resource aws_default_route_table default {
  default_route_table_id = aws_vpc.default.default_route_table_id
  tags                   = merge(local.tags, { Name : "${local.base_name}-default" })
}
