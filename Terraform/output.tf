output "user_name" {
  value = aws_iam_user.user.name
}

output "iam_access_key_id" {
  value = aws_iam_access_key.ak.id
}

output "iam_secret_access_key" {
  value     = aws_iam_access_key.ak.secret
  sensitive = true
}

output "iam_password" {
  value     = aws_iam_user_login_profile.user_login
  sensitive = true
}


output "policy" {
  value = {
    iam_access = aws_iam_user_policy_attachment.iam_full_access.policy_arn
    s3_access  = aws_iam_user_policy_attachment.s3_access.policy_arn
    vpc_access = aws_iam_user_policy_attachment.vpc_access.policy_arn
  }
}


output "vpc" {
  value = {
    id   = aws_vpc.k8s-vpc.id
    name = aws_vpc.k8s-vpc.tags
  }
}

output "private-subnets" {
  value = {
    private-subnet-1      = aws_subnet.private-subnet-ap-south-1a.id
    private-subnet-2      = aws_subnet.private-subnet-ap-south-1b.id
    private-subnet-1-Name = aws_subnet.private-subnet-ap-south-1a.tags.Name
    private-subnet-2-Name = aws_subnet.private-subnet-ap-south-1b.tags.Name
  }
}


output "public-subnets" {
  value = {
    private-subnet-1      = aws_subnet.public-subnet-ap-south-1a.id
    private-subnet-2      = aws_subnet.public-subnet-ap-south-1b.id
    private-subnet-1-Name = aws_subnet.public-subnet-ap-south-1a.tags.Name
    private-subnet-2-Name = aws_subnet.public-subnet-ap-south-1b.tags.Name
  }
}