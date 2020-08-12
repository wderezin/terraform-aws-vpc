resource aws_subnet public {
  count                           = length(data.aws_availability_zones.default.zone_ids)
  vpc_id                          = aws_vpc.default.id
  cidr_block                      = local.subnet_cidrs[count.index]
  availability_zone_id            = data.aws_availability_zones.default.zone_ids[count.index]
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true

  ipv6_cidr_block = cidrsubnet(aws_vpc.default.ipv6_cidr_block, 8, count.index)
  tags = merge(local.tags, {
    Name : local.subnet_name
    network : "public",
    default : count.index == 0 ? "yes" : "no"
  })
}

resource aws_route_table public {
  vpc_id = aws_vpc.default.id
  tags   = merge(local.tags, { Name : local.subnet_name })
}

resource aws_route_table_association public {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource aws_route public_internet_gateway {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id

  timeouts {
    create = "5m"
  }
}

resource aws_route public_internet_gateway_ipv6 {
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.default.id
}
