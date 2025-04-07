resource "aws_iam_user" "user" {
  name = var.iam_user
}


resource "aws_iam_access_key" "ak" {
  user = aws_iam_user.user.name
}


resource "aws_eks_access_entry" "dev-1" {
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = aws_iam_user.user.arn
  kubernetes_groups = ["my-writer"]
}

resource "aws_iam_user_login_profile" "user_login" {
  user                    = aws_iam_user.user.name
  password_length         = 9
  password_reset_required = true
}

resource "aws_iam_user_policy_attachment" "iam_full_access" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_user_policy_attachment" "s3_access" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"

}

resource "aws_iam_user_policy_attachment" "vpc_access" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_user_policy_attachment" "ec2_access" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_user_policy_attachment" "eks_access" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_user_policy_attachment" "rds_access" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_user_policy_attachment" "secret_manager_access" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}