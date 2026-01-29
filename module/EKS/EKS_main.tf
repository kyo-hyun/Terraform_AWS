resource "aws_eks_cluster" "example" {
  name = var.name

  access_config {
    authentication_mode = "API"
  }

  role_arn = var.cluster_role
  version  = var.eks_version

  vpc_config {
    subnet_ids              = var.subnets
    endpoint_public_access  = lookup(var.api_access,"public_access",false)
    endpoint_private_access = lookup(var.api_access,"private_access",false)
  }
}

resource "aws_eks_access_entry" "example" {
  cluster_name  = aws_eks_cluster.example.name
  principal_arn = var.access_user
}

resource "aws_eks_access_policy_association" "example" {
  cluster_name  = aws_eks_cluster.example.name
  policy_arn    = var.user_policy
  principal_arn = var.access_user

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_node_group" "example_managed_node_group" {
  for_each        = {for ng in var.node_group : ng.node_group => ng}
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = each.key
  node_role_arn   = each.value.node_role
  subnet_ids      = aws_eks_cluster.example.vpc_config[0].subnet_ids

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size    
    min_size     = each.value.min_size    
  }

  instance_types = each.value.instance_type
  ami_type       = "AL2023_x86_64_STANDARD"

  disk_size = each.value.disk_size

  labels = {
    "app" = "example"
    "env" = "dev"
  }

  tags = {
    "Name"        = "example-eks-managed-node"
    "Environment" = "Development"
  }
}