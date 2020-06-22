
output public_subnet_ids {
  value = aws_subnet.public[*].id
}

output vpc {
  value = aws_vpc.default
}

output network_info {
  value = {
    vpc_id            = aws_vpc.default.id
    subnet_ids = aws_subnet.public[*].id
    cidr_blocks = [ aws_vpc.default.cidr_block ]
  }
}

output tags {
  value = local.base_tags
}