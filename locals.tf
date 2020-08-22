data aws_region default {}

data aws_availability_zones default {
  all_availability_zones = false
}

locals {
  enable_ssh_proxy_count = var.enable_ssh_proxy ? 1 : 0

  //  Make sure these are set
  cluster = var.cluster

  base_tags = merge(
    //    Default Tag Values
    {
      managed-by : "terraform"
    },
    //    User Tag Value
    var.tags,
    //    Fixed tags for module
    {
      Application : "daringway/vpc",
      Cluster     : local.cluster,
      Function    : "network"
    }
  )

  base_name   = local.cluster
  subnet_name = "${local.base_name}-public"

  tags = merge(local.base_tags, { Name : local.base_name })

  ssh_name = "${local.base_name}-sshproxy"
  ssh_tags = merge(local.tags, { Name : "${local.base_name}-sshproxy", Function : "sshproxy" })

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