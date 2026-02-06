locals {
  route_table_list = {
    "demo-ec2-rt" = {
      vpc_id          = "demo-vpc"
      #subnet_assoc = ["demo-a-ec2-public-snet"]
      edge_assoc      = "kim_vpc_igw"
      routes = {
        1 = {
          destination    = "0.0.0.0/0"
          vpc_endpoint   = "demo-nfw"
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
                  "route_key"    = route_key
                  "destination"  = route_value.destination
                  "target"       = try(module.igw[route_value.target].get_igw_id, module.natgw[route_value.target].get_natgw_id,null)
                  "vpc_endpoint" = try(module.nfw[route_value.vpc_endpoint].get_nfw_endpoint_id,null)
                  }
               ]
  vpc_id     = module.vpc[each.value.vpc_id].get_vpc_id
  subnet_ids = try({ for subnet_id in each.value.subnet_assoc : subnet_id => module.vpc[each.value.vpc_id].get_subnet_id[subnet_id] },{})
  edge_name  = each.value.edge_assoc
  edge_id    = try(module.igw[each.value.edge_assoc].get_igw_id, null)
}