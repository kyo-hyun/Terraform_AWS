locals {
  target_group_list = {
    "tg-http" = {
        vpc_id    = "A-vpc"
        port      = 80
        protocol  = "HTTP"
        ec2_id    = ["rygus-test"]
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
    ec2_id      = {for ec2 in each.value.ec2_id : ec2 => module.ec2[ec2].get_ec2_id}
    path        = each.value.path
}