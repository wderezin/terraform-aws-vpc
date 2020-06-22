terraform {
  required_version = "~> 0.12.0"
  required_providers {
    aws = "~> 2.0"
  }
}

data aws_region default {}

data aws_availability_zones default {
  all_availability_zones = false
}
