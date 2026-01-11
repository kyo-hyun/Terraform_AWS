locals {
  natgw_list = {
    # "test-nat" = {
    #   vpc     = "vpc-hub"
    #   subnet  = "A-public-1-sb"
    #   eip     = "eip_test3"
    # }
  }
}

module "natgw" {
  source    = "./module/NATGW"
  for_each  = local.natgw_list
  name      = each.key
  subnet_id = module.vpc[each.value.vpc].get_subnet_id[each.value.subnet]
  eip_id    = module.eip[each.value.eip].get_eip_id
}