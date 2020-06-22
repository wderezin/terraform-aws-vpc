resource aws_vpc_endpoint s3 {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.${data.aws_region.default.name}.s3"

  tags = merge(local.tags, { Name : "${local.base_name}-s3" })
}

resource aws_vpc_endpoint dynamodb {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.${data.aws_region.default.name}.dynamodb"

  tags = merge(local.tags, { Name : "${local.base_name}-dynamodb" })
}