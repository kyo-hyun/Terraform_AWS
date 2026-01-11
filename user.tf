locals {
  iam_users = {
    # "sts-user" = {
    #   policy   = ["AIOpsOperatorAccess","AdministratorAccess","sts"]
    #   tags = {
    #     owner = "kim",
    #     env   = "terraform"
    #   }
    # }
  }
}

module "iam_user" {
  source              = "./module/IAM_User"
  for_each            = local.iam_users
  name                = each.key
  path                = try(each.value.path, null)
  policy              = [for policy in each.value.policy : {
                          "custom_policy" = contains(keys(module.policy), policy) ? true : false
                          "policy"        = contains(keys(module.policy), policy) ? module.policy[policy].get_policy_arn : policy
                          "policy_name"   = policy
                        }]
  tags                = each.value.tags
}