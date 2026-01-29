locals {
  igw_list = {
    "kim_vpc_igw" = {
      vpc_attach = "test-vpc"
    }
  }
}

module "igw" {
  source   = "./module/IGW"
  for_each = local.igw_list

  name   = each.key
  vpc_id = module.vpc[each.value.vpc_attach].get_vpc_id

}