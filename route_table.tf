locals {
  route_table_list = {
    "hub-mgmt-rt" = {
      vpc_id     = "test-vpc"
      subnet_ids = ["test-snet-a","test-snet-c","test-snet-lb-a","test-snet-lb-c"]
      routes = {
        1 = {
          destination = "0.0.0.0/0"
          target      = "kim_vpc_igw"
        }
      }
    }
  }
}

module "RouteTable" {
  source     = "./module/RouteTable"
  for_each   = local.route_table_list
  name       = each.key
  routes     = [for route_key, route_value in each.value.routes: {
                  "route_key"   = route_key
                  "destination" = route_value.destination
                  "target"      = try(module.igw[route_value.target].get_igw_id, module.natgw[route_value.target].get_natgw_id,null)
                }
               ]
  vpc_id     = module.vpc[each.value.vpc_id].get_vpc_id
  subnet_ids = { for subnet_id in each.value.subnet_ids : subnet_id => module.vpc[each.value.vpc_id].get_subnet_id[subnet_id] }
}