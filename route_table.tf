locals {
  route_table_list = {
    "demo-igw-rt" = {
      vpc_id          = "demo-vpc"
      edge_assoc      = "demo-igw"
      routes = {
        1 = {
          destination    = "10.0.4.0/24"
          vpc_endpoint   = "demo-nfw"
        }
        2 = {
          destination    = "10.0.5.0/24"
          vpc_endpoint   = "demo-nfw"
        }
      }
    }

    "demo-nfw-rt" = {
      vpc_id          = "demo-vpc"
      subnet_assoc    = ["demo-a-nfw-public-snet","demo-c-nfw-public-snet"]
      routes = {
        1 = {
          destination = "0.0.0.0/0"
          target      = "demo-igw"
        }
      }
    }

    "demo-alb-rt" = {
      vpc_id          = "demo-vpc"
      subnet_assoc    = ["demo-a-tgw-private-snet","demo-c-tgw-private-snet"]
      routes = {
        1 = {
          destination  = "0.0.0.0/0"
          vpc_endpoint = "demo-nfw"
        }
      }
    }
  }
}

module "RouteTable" {
  source       = "./module/RouteTable"
  for_each     = local.route_table_list
  name         = each.key
  routes       = [for route_key, route_value in each.value.routes: {
                  "route_key"    = route_key
                  "destination"  = route_value.destination
                  "target"       = try(module.igw[route_value.target].get_igw_id, module.natgw[route_value.target].get_natgw_id,null)
                  "vpc_endpoint" = try(one(module.nfw[route_value.vpc_endpoint].get_nfw_endpoint_id), null)
                  }
               ]
  vpc_id       = module.vpc[each.value.vpc_id].get_vpc_id
  subnet_names = try(each.value.subnet_assoc, [])
  subnet_ids   = try({ for subnet_id in each.value.subnet_assoc : subnet_id => module.vpc[each.value.vpc_id].get_subnet_id[subnet_id] },{})
  edge_name    = try(each.value.edge_assoc, null)
  edge_id      = try(module.igw[each.value.edge_assoc].get_igw_id, null)
}