locals {
    role_list = {
        "eks-cluster-role" = {
            policy              = ["AmazonEKSBlockStoragePolicy","AmazonEKSClusterPolicy","AmazonEKSComputePolicy","AmazonEKSLoadBalancingPolicy","AmazonEKSNetworkingPolicy"]
            trusted_entities    = {
              Version = "2012-10-17",
              Statement = [
                {
                  Effect = "Allow",
                  Principal = {
                    Service = "eks.amazonaws.com"
                  },
                  Action = "sts:AssumeRole"
                }
              ]
            }
        }

        "eks-ng-role" = {
            policy              = ["AmazonEC2ContainerRegistryReadOnly","AmazonEKS_CNI_Policy","AmazonEKSWorkerNodePolicy"]
            trusted_entities    = {
              Version = "2012-10-17",
              Statement = [
                {
                  Effect = "Allow",
                  Principal = {
                    Service = "ec2.amazonaws.com"
                  },
                  Action = "sts:AssumeRole"
                }
              ]
            }
        }
    }
}

module "IAM_Role" {
    source              = "./module/IAM_Role" 
    for_each            = local.role_list
    name                = each.key
    policy              = [for policy in each.value.policy : {
                        "custom_policy" = contains(keys(module.policy), policy) ? true : false
                        "policy"        = contains(keys(module.policy), policy) ? module.policy[policy].get_policy_arn : policy
                        "policy_name"   = policy
                        }]
    trusted_entities    = each.value.trusted_entities
}