locals {
  igw_list = {
    "demo-igw" = {
      vpc_attach = "demo-vpc"
    }

    "spoke1-igw" = {
      vpc_attach = "spoke1-vpc"
    }

    "spoke2-igw" = {
      vpc_attach = "spoke2-vpc"
    }
  }
}

module "igw" {
  source   = "./module/IGW"
  for_each = local.igw_list
  name     = each.key
  vpc_id   = module.vpc[each.value.vpc_attach].get_vpc_id
}