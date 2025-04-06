resource "aws_eks_cluster" "k8s_cluster" {
  name                      = "demo-eks"
  role_arn                  = aws_iam_role.eks_master_role.arn
  version                   = "1.31"
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]


  vpc_config {
    subnet_ids = [
      aws_subnet.private-subnet-ap-south-1a.id,
      aws_subnet.private-subnet-ap-south-1b.id,
      aws_subnet.public-subnet-ap-south-1a.id,
      aws_subnet.public-subnet-ap-south-1b.id,
    ]
    endpoint_public_access  = true
    endpoint_private_access = false
  }


  access_config {
authentication_mode = "API"
bootstrap_cluster_creator_admin_permissions =true
  }

  depends_on = [aws_iam_user_policy.eks_cluster_inline_policy]
}