locals {
  vpc_list = {
    "demo-vpc" = {
      cidr_block = "10.0.0.0/16"
      subnet = {
        "demo-a-ec2-public-snet" = {
          cidr_block              = "10.0.0.0/24"
          availability_zone       = "ap-northeast-2a"
          map_public_ip_on_launch = "true"
        }

        "demo-c-ec2-public-snet" = {
          cidr_block              = "10.0.1.0/24"
          availability_zone       = "ap-northeast-2c"
          map_public_ip_on_launch = "true"
        }

        "demo-a-nfw-public-snet" = {
          cidr_block              = "10.0.2.0/24"
          availability_zone       = "ap-northeast-2a"
        }

        "demo-c-nfw-public-snet" = {
          cidr_block              = "10.0.3.0/24"
          availability_zone       = "ap-northeast-2c"
        }

        "demo-a-tgw-private-snet" = {
          cidr_block              = "10.0.4.0/24"
          availability_zone       = "ap-northeast-2a"
        }

        "demo-c-tgw-private-snet" = {
          cidr_block              = "10.0.5.0/24"
          availability_zone       = "ap-northeast-2c"
        }
      }
    }

    "spoke1-vpc" = {
      cidr_block = "10.100.0.0/16"
      subnet = {
        "spoke1-a-tgw-private-snet" = {
          cidr_block              = "10.100.0.0/24"
          availability_zone       = "ap-northeast-2a"
        }

        "spoke1-c-tgw-private-snet" = {
          cidr_block              = "10.100.1.0/24"
          availability_zone       = "ap-northeast-2c"
        }

        "spoke1-a-eks-public-snet" = {
          cidr_block              = "10.100.2.0/24"
          availability_zone       = "ap-northeast-2a"
          map_public_ip_on_launch = "true"
        }

        "spoke1-c-eks-public-snet" = {
          cidr_block              = "10.100.3.0/24"
          availability_zone       = "ap-northeast-2c"
          map_public_ip_on_launch = "true"
        }
      }
    }

    "spoke2-vpc" = {
      cidr_block = "10.150.0.0/16"
      subnet = {
        "spoke2-a-tgw-private-snet" = {
          cidr_block              = "10.150.0.0/24"
          availability_zone       = "ap-northeast-2a"
        }

        "spoke2-c-tgw-private-snet" = {
          cidr_block              = "10.150.1.0/24"
          availability_zone       = "ap-northeast-2c"
        }

        "spoke2-a-eks-public-snet" = {
          cidr_block              = "10.150.2.0/24"
          availability_zone       = "ap-northeast-2a"
          map_public_ip_on_launch = "true"
        }

        "spoke2-c-eks-public-snet" = {
          cidr_block              = "10.150.3.0/24"
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