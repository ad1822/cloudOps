resource "aws_eks_cluster" "k8s_cluster" {
  name     = "demo-eks"
  role_arn = aws_iam_role.demo.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = [
      aws_subnet.private-subnet-ap-south-1a.id,
      aws_subnet.private-subnet-ap-south-1b.id,
      aws_subnet.public-subnet-ap-south-1a.id,
      aws_subnet.public-subnet-ap-south-1b.id,
    ]
    # endpoint_public_access  = true
    # endpoint_private_access = true
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}