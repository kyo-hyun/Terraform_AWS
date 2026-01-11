locals {
  LB_List = {
    "test-alb" = {
      internal              = false
      load_balancer_type    = "application"
      security_groups       = ["test-sg1"]
      vpc                   = "vpc-hub"
      subnets               = ["A-public-1-sb","A-public-2-sb"]
      certificate_arn       = "arn:aws:acm:ap-northeast-2:364010288789:certificate/8cce0133-d33c-4b28-99fb-7f53acfef309"
      listener = {
        "http_listener" = {
          port              = 443
          protocol          = "HTTPS"
          action            = "forward"
          default_target    = {
            1 = {
              tg      = "tg-http"
              weight  = 1
            }
          }
          rule = {

          }
        }

      }
    }
  }
}

# 일단 룰 하나당 타겟그룹 하나만 설정
# module "lb" {
#   source                = "./module/LB"
#   for_each              = local.LB_List
#   name                  = each.key
#   internal              = each.value.internal
#   load_balancer_type    = each.value.load_balancer_type
#   certificate_arn       = try(each.value.certificate_arn,null)
#   security_groups       = [for sg_id in each.value.security_groups : module.sg[sg_id].get_sg_id]
#   subnets               = [for subnet_id in each.value.subnets : module.vpc[each.value.vpc].get_subnet_id[subnet_id]]
#   nlb_listener          = each.value.load_balancer_type == "network" ? [
#                             for nlb_listener_key, nlb_listener_value in each.value.listener : {
#                               "listener"        = nlb_listener_key
#                               "port"            = nlb_listener_value.port
#                               "protocol"        = nlb_listener_value.protocol
#                               "action"          = nlb_listener_value.action
#                               "default_target"  = module.target_group[nlb_listener_value.default_target].get_tg_arn
#                             }
#                           ] : []
#   default_target_group  = each.value.load_balancer_type == "application" ? flatten([
#                             for listener_key, listener_value in each.value.listener : [
#                               for default_target_key, default_target_value in listener_value.default_target : {
#                                 "target_group" = default_target_value.tg
#                                 "tg_arn"       = module.target_group[default_target_value.tg].get_tg_arn
#                                 "weight"       = default_target_value.weight
#                               }
#                             ]
#                           ]) : []
#   alb_listener          = each.value.load_balancer_type == "application" ? each.value.listener : {}
#   rule                  = each.value.load_balancer_type == "application" ? flatten([
#                             for listener_key,listener_value in each.value.listener : [
#                               for rule_key,rule_value in listener_value.rule : {
#                                 "listener"     = listener_key
#                                 "rule"         = rule_key
#                                 "priority"     = rule_value.priority
#                                 "target_group" = module.target_group[rule_value.target_group].get_tg_arn
#                                 "action_type"  = rule_value.action_type
#                                 "path"         = rule_value.path
#                               }
#                             ]
#                           ]) : []
# }