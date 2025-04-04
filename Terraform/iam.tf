
resource "aws_iam_user" "user" {
  name = var.iam_user
}


resource "aws_iam_access_key" "ak" {
  user = aws_iam_user.user.name
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


resource "aws_iam_user_policy" "eks_cluster_inline_policy" {
  name = "eks-cluster-inline-policy"
  user = aws_iam_user.user.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "eks:CreateCluster",
          "eks:*",
          "ssmmessages:*"
        ],
        "Resource" : [
          "*",
          "*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParameter",
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:DeleteCluster",
          "cloudformation:CreateStack",
          "eks:UpdateClusterConfig",
          "eks:CreateNodegroup",
          "eks:TagResource",
          "eks:UntagResource",
          "eks:AccessKubernetesApi",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup",
          "cloudformation:*"
        ],
        "Resource" : "*"
      }
    ]
    }
  )

}


resource "aws_iam_role" "eks_master_role" {
  name = "eks-master-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com" # EKS service needs this
        }
      },
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::051826726751:user/dev" # Replace with your user ARN
        }
      }
    ]
  })
}