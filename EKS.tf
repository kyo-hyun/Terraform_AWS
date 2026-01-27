locals {
  eks_list = {
    "spoke1-eks" = {
      version             = "1.33"
      vpc                 = "test-vpc"
      subnet              = ["test-snet-a","test-snet-c"]

      # cluster role
      cluster_role        = "eks-cluster-role"

      # access user
      access_user         = "arn:aws:iam::364010288789:user/tf_user"
      user_policy         = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

      # node group
      node_group    = {
        "system-ng" = {
          node_role       = "eks-ng-role"
          instance_types  = "t3.large"
          disk_size       = 20
          desired_size    = 1
          max_size        = 1
          min_size        = 1
        }
      }
    }
  }
}

module "eks" {
  source        = "./module/EKS"
  for_each      = local.eks_list

  name          = each.key
  eks_version   = each.value.version
  subnets       = [for subnet in each.value.subnet : module.vpc[each.value.vpc].get_subnet_id[subnet]]
  cluster_role  = module.IAM_Role[each.value.cluster_role].get_role_arn
  access_user   = each.value.access_user
  user_policy   = each.value.user_policy
  node_group     = [for ng_key, ng_value in each.value.node_group : {
    "node_group"      = ng_key
    "node_role"       = module.IAM_Role[ng_value.node_role].get_role_arn
    "instance_type"   = [ng_value.instance_types]
    "disk_size"       = ng_value.disk_size
    "desired_size"    = ng_value.desired_size
    "max_size"        = ng_value.max_size
    "min_size"        = ng_value.min_size
    }
  ]
}