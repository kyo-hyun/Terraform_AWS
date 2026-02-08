locals {
  eip_list = {
    "eip_nlb" = {

    }
    "eip_ec2_mgmt" = {

    }
  }
}

module "eip" {
  for_each = local.eip_list
  source   = "./module/EIP"
  name     = each.key
}