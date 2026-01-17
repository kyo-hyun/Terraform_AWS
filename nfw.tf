locals {
  nfw_list = {
    "main-nfw" = {
      name            = "main-firewall"
      policy_name     = "main-firewall-policy"
      rule_group_name = "pass-all-rule-group"
    }
  }
}

module "nfw" {
  source   = "./module/NFW"
  for_each = local.nfw_list

  name            = each.value.name
  policy_name     = each.value.policy_name
  rule_group_name = each.value.rule_group_name

  vpc_id      = module.vpc.vpc_id
  subnets_ids = module.vpc.public_subnets
}
