locals {
  vpc_list = {
    "test-vpc" = {
      cidr_block = "10.0.0.0/16"
      subnet = {
        "test-snet-a" = {
          cidr_block              = "10.0.0.0/24"
          availability_zone       = "ap-northeast-2a"
          map_public_ip_on_launch = "true"
        }

        "test-snet-lb-a" = {
          cidr_block              = "10.0.2.0/24"
          availability_zone       = "ap-northeast-2a"
          map_public_ip_on_launch = "true"
        }

        "test-snet-lb-c" = {
          cidr_block              = "10.0.3.0/24"
          availability_zone       = "ap-northeast-2c"
          map_public_ip_on_launch = "true"
        }

        "test-snet-c" = {
          cidr_block              = "10.0.1.0/24"
          availability_zone       = "ap-northeast-2c"
          map_public_ip_on_launch = "true"
        }
      }
    }
  }
}

module "vpc" {
  source     = "./module/VPC"
  for_each   = local.vpc_list
  name       = each.key
  cidr_block = each.value.cidr_block
  subnet     = each.value.subnet
}