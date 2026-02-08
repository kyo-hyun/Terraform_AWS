locals {
  target_group_list = {
    "tg-http" = {
        vpc_id    = "demo-vpc"
        port      = 80
        protocol  = "HTTP"
        ec2_id    = ["10.150.0.5","10.100.0.5"]
        path      = null
    }
  }
}

module "target_group" {
    source      = "./module/TargetGroup"
    for_each    = local.target_group_list
    name        = each.key
    vpc_id      = module.vpc[each.value.vpc_id].get_vpc_id
    port        = each.value.port
    protocol    = each.value.protocol
    #ec2_id      = {for ec2 in each.value.ec2_id : ec2 => module.ec2[ec2].get_ec2_id}
    ec2_id      = each.value.ec2_id

    path        = each.value.path
}