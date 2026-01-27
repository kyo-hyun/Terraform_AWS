locals {
  nfw_list = {
    "main-nfw" = {
      vpc    = "test-vpc"
      subnet = "test-nfw-snet-a"

      stateless_rules = [
        {
          priority = 10
          action   = "aws:drop" 
          protocol = [6]        
          src      = "10.0.0.0/8"
          dst      = "0.0.0.0/0"
          src_port = { from = 0, to = 65535 }
          dst_port = { from = 22, to = 22 }
        },
        {
          priority = 100
          action   = "aws:pass"
          protocol = [6, 17]
          src      = "0.0.0.0/0"
          dst      = "0.0.0.0/0"
          src_port = { from = 0, to = 65535 }
          dst_port = { from = 0, to = 65535 }
        }
      ]

      stateful_rules = [
        {
          description = "Allow HTTPS to Specific External CIDR"
          protocol    = "TCP"
          src         = "10.0.0.0/8"
          src_port    = "any"
          dst         = "1.2.3.4/32"
          dst_port    = "443"
          direction   = "FORWARD"
          action      = "PASS"
        },
        {
          description = "Drop SSH from Untrusted Network"
          protocol    = "TCP"
          src         = "0.0.0.0/0"
          src_port    = "any"
          dst         = "10.0.1.0/24"
          dst_port    = "22"
          direction   = "FORWARD"
          action      = "DROP"
        }
      ]
    }
  }
}

module "nfw" {
  source          = "./module/NFW"
  for_each        = local.nfw_list

  name            = each.key
  vpc_id          = module.vpc[each.value.vpc].get_vpc_id
  subnet_id       = module.vpc[each.value.vpc].get_subnet_id[each.value.subnet]
  stateless_rules = each.value.stateless_rules
  stateful_rules  = each.value.stateful_rules
}
