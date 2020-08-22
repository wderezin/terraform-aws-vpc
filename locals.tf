data aws_region default {}

data aws_availability_zones default {
  all_availability_zones = false
}

locals {
  enable_ssh_proxy_count = var.enable_ssh_proxy ? 1 : 0

  name = var.name

  tags = merge(
    //    Default Tag Values
    {
      managed-by : "terraform"
    },
    //    User Tag Value
    var.tags,
    //    Fixed tags for module
    {
      Name        : local.name,
    }
  )

  subnet_name = "${local.name}-public"

  ssh_name = "${local.name}-sshproxy"
  ssh_tags = merge(local.tags, { Name : "${local.name}-sshproxy", Function : "sshproxy" })

  vpc_cidr = "172.31.0.0/16"

  subnet_cidrs = [
    "172.31.0.0/20",
    "172.31.16.0/20",
    "172.31.32.0/20",
    "172.31.48.0/20",
    "172.31.64.0/20",
    "172.31.80.0/20",
    "172.31.96.0/20"
  ]

}