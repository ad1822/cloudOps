#! iam user
output "iam_user" {
  description = "iam user name"
  value       = aws_iam_user.user.name
}

output "iam_access_key" {
  description = "The access key ID for IAM user"
  value       = aws_iam_access_key.ak.id
}

output "iam_secret_key" {
  description = "The secret access key for IAM user (sensitive)"
  value       = aws_iam_access_key.ak.secret
  sensitive   = true
}

output "iam_user_password" {
  description = "The IAM user console login password (sensitive)"
  value       = aws_iam_user_login_profile.user_login
  sensitive   = true
}

#! vpc
output "vpc" {
  description = "Details about the VPC"
  value = {
    id         = aws_vpc.main.id
    name       = aws_vpc.main.tags.Name
    cidr_block = aws_vpc.main.cidr_block
  }
}

#! private subnets
output "private_subnets" {
  description = "Details about private subnets"
  value = {
    subnet_1_id   = aws_subnet.private_zone1.id
    subnet_2_id   = aws_subnet.private_zone2.id
    subnet_1_name = aws_subnet.private_zone1.tags.Name
    subnet_2_name = aws_subnet.private_zone2.tags.Name
    subnet_1_az   = aws_subnet.private_zone1.availability_zone
    subnet_2_az   = aws_subnet.private_zone2.availability_zone
  }
}

#! nat gateway
output "nat_gateway_eip" {
  description = "Elastic IP address associated with NAT Gateway"
  value       = aws_eip.nat.address
}


#! public subnets
output "public_subnets" {
  description = "Details about private subnets"
  value = {
    subnet_1_id   = aws_subnet.public_zone1.id
    subnet_2_id   = aws_subnet.public_zone2.id
    subnet_1_name = aws_subnet.public_zone1.tags.Name
    subnet_2_name = aws_subnet.public_zone2.tags.Name
    subnet_1_az   = aws_subnet.public_zone1.availability_zone
    subnet_2_az   = aws_subnet.public_zone2.availability_zone
  }
}

#! Internet Gateway
output "igw" {
  description = "Details about Internet Gateway"
  value       = aws_internet_gateway.igw.tags.Name
}


#! EKS Outputs
output "eks_cluster" {
  description = "Details about the EKS cluster"
  value = {
    name       = aws_eks_cluster.eks.name
    arn        = aws_eks_cluster.eks.arn
    endpoint   = aws_eks_cluster.eks.endpoint
    version    = aws_eks_cluster.eks.version
    status     = aws_eks_cluster.eks.status
    created_at = aws_eks_cluster.eks.created_at
  }
}

#! NodeGroup
output "eks_node_groups" {
  description = "Details about EKS node groups"
  value = {
    node_group_name = aws_eks_node_group.general.node_group_name
    cluster_name    = aws_eks_node_group.general.cluster_name
    node_role_arn   = aws_eks_node_group.general.node_role_arn
    status          = aws_eks_node_group.general.status
  }
}

#! RBAC
output "rbac" {
  value = aws_eks_access_entry.dev-1.kubernetes_groups
}

#! Bucket
output "bucket" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}

#! Who Am I
output "whoami" {
  value = data.aws_caller_identity.current.arn
}

#! RDS
output "db_host" {
  value = aws_db_instance.gindb.address
}

output "db_user" {
  value = aws_db_instance.gindb.username
}

output "db_user_password" {
  value     = aws_db_instance.gindb.password
  sensitive = true
}

#! CloudFront

output "cloudFront" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}