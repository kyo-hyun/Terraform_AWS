locals {
  security_group_list = {
    "demo-sg" = {
      vpc_id = "demo-vpc"
      ingress_rule = {
        "in_ssh_allow_home" = {
          cidr_ipv4   = ["218.48.21.223/32","20.196.90.96/32","10.0.0.0/24","4.230.131.122/32"]
          from_port   = 22
          to_port     = 80
          ip_protocol = "tcp"
        }

        "in_http_allow_nlb" = {
          cidr_ipv4   = ["10.0.2.0/24"]
          from_port   = 80
          to_port     = 80
          ip_protocol = "tcp"
        }
      }

      egress_rule = {
        "out_all" = {
          cidr_ipv4   = ["0.0.0.0/0"]
          from_port   = null
          to_port     = null
          ip_protocol = -1
        }
      }
    }
  }
}

module "sg" {
  source       = "./module/SG"
  for_each     = local.security_group_list
  name         = each.key
  ingress_rule = each.value.ingress_rule
  egress_rule  = try(each.value.egress_rule,null)
  vpcid        = module.vpc[each.value.vpc_id].get_vpc_id
}