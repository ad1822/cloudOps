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

resource "aws_iam_user_policy_attachment" "cdn_access" {
  user       = aws_iam_user.user.name
  policy_arn = "arn:aws:iam::aws:policy/CloudFrontFullAccess"
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


data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.eks.name
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}
resource "aws_iam_role" "backend_irsa_role" {
  name = "eks-backend-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:prod:gin-app-sa",
            "${replace(aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_irsa_role" {
  role       = aws_iam_role.backend_irsa_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Create a more restrictive policy if needed (recommended)
resource "aws_iam_policy" "specific_bucket_access" {
  name        = "specific-bucket-access"
  description = "Policy for specific S3 bucket access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = [
          "arn:aws:s3:::prod-eks-gin-bucket-backend",
          "arn:aws:s3:::prod-eks-gin-bucket-backend./*"
        ]

      }

    ]
  })
}

resource "aws_iam_role_policy_attachment" "irsa_sts" {
  role       = aws_iam_role.backend_irsa_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy" "sts_permissions" {
  name = "sts-permissions"
  role = aws_iam_role.backend_irsa_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRoleWithWebIdentity",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "specific_bucket_access" {
  role       = aws_iam_role.backend_irsa_role.name
  policy_arn = aws_iam_policy.specific_bucket_access.arn
}