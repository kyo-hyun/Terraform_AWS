locals {
    tgw_list = {
        "demo-tgw" = {
          amazon_side_asn = 64512
          route_table = {
            "demo_rt" = {
              route = {
                1 = {
                    destination_cidr_block = "11.0.0.0/16"
                    destination_vpc        = "demo-vpc"
                }
                2 = {
                    destination_cidr_block = "12.0.0.0/16"
                    destination_vpc        = "demo-vpc"
                }
              }
            }

            "spoke1_rt" = {
              route = {
                1 = {
                  destination_cidr_block = "10.0.0.0/16"
                  destination_vpc        = "spoke1-vpc"
                }
              }
            }

            "spoke2_rt" = {
              route = {
                1 = {
                  destination_cidr_block = "10.0.0.0/16"
                  destination_vpc        = "spoke2-vpc"
                }
              }
            }
          }

           vpc_connections = {
             "demo-vpc" = {
               subnet_ids  = ["demo-a-tgw-private-snet","demo-c-tgw-private-snet"]
               route_table = "demo_rt"
             }
             "spoke1-vpc" = {
               subnet_ids  = ["spoke1-a-tgw-private-snet","spoke1-c-tgw-private-snet"]
               route_table = "spoke1_rt"
             }
             "spoke2-vpc" = {
               subnet_ids  = ["spoke2-a-tgw-private-snet","spoke2-c-tgw-private-snet"]
               route_table = "spoke2_rt"
             }
           }

           tags = {
             Env = "Demo"
           }
        }
    }
}

module "aws_tgw" {
  source          = "./module/tgw"
  for_each        = local.tgw_list
  name            = each.key
  amazon_side_asn = each.value.amazon_side_asn
  route_table     = each.value.route_table
  tags            = each.value.tags
  vpc_connections = {
    for name, conn in each.value.vpc_connections :
    name => {
      vpc_id      = module.vpc[name].get_vpc_id
      route_table = conn.route_table
      subnet_ids  = [
        for sn_key in conn.subnet_ids :
        module.vpc[name].get_subnet_id[sn_key]
      ]
    }
  }
}