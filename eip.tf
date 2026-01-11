locals {
  eip_list = {
    "eip_nlb" = {

    }

    "eip_test2" = {

    }

    "eip_test3" = {

    }

    "eip_test4" = {

    }
  }
}

module "eip" {
  for_each = local.eip_list
  source   = "./module/EIP"
  name     = each.key
}