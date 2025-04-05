# IAM User Outputs
output "iam_user_name" {
  description = "The name of the IAM user"
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

# IAM Policy Outputs
output "attached_policies" {
  description = "ARNs of all attached IAM policies"
  value = {
    iam_access = aws_iam_user_policy_attachment.iam_full_access.policy_arn
    s3_access  = aws_iam_user_policy_attachment.s3_access.policy_arn
    vpc_access = aws_iam_user_policy_attachment.vpc_access.policy_arn
    ec2_access = aws_iam_user_policy_attachment.ec2_access.policy_arn
    # eks_access = aws_iam_role.eks_master_role.name
  }
}

# Network Outputs
output "vpc_details" {
  description = "Details about the VPC"
  value = {
    id         = aws_vpc.k8s-vpc.id
    name       = aws_vpc.k8s-vpc.tags.Name
    cidr_block = aws_vpc.k8s-vpc.cidr_block
  }
}

output "private_subnets" {
  description = "Details about private subnets"
  value = {
    subnet_1_id   = aws_subnet.private-subnet-ap-south-1a.id
    subnet_2_id   = aws_subnet.private-subnet-ap-south-1b.id
    subnet_1_name = aws_subnet.private-subnet-ap-south-1a.tags.Name
    subnet_2_name = aws_subnet.private-subnet-ap-south-1b.tags.Name
    subnet_1_az   = aws_subnet.private-subnet-ap-south-1a.availability_zone
    subnet_2_az   = aws_subnet.private-subnet-ap-south-1b.availability_zone
  }
}

output "public_subnets" {
  description = "Details about public subnets"
  value = {
    subnet_1_id   = aws_subnet.public-subnet-ap-south-1a.id
    subnet_2_id   = aws_subnet.public-subnet-ap-south-1b.id
    subnet_1_name = aws_subnet.public-subnet-ap-south-1a.tags.Name
    subnet_2_name = aws_subnet.public-subnet-ap-south-1b.tags.Name
    subnet_1_az   = aws_subnet.public-subnet-ap-south-1a.availability_zone
    subnet_2_az   = aws_subnet.public-subnet-ap-south-1b.availability_zone
  }
}

output "nat_gateway_eip" {
  description = "Elastic IP address associated with NAT Gateway"
  value       = aws_eip.nat.address
}

# EKS Outputs
# output "eks_cluster" {
#   description = "Details about the EKS cluster"
#   value = {
#     name       = aws_eks_cluster.k8s_cluster.name
#     arn        = aws_eks_cluster.k8s_cluster.arn
#     endpoint   = aws_eks_cluster.k8s_cluster.endpoint
#     version    = aws_eks_cluster.k8s_cluster.version
#     status     = aws_eks_cluster.k8s_cluster.status
#     created_at = aws_eks_cluster.k8s_cluster.created_at
#   }
# }

# output "eks_node_groups" {
#   description = "Details about EKS node groups"
#   value = {
#     node_group_name = aws_eks_node_group.private-nodes.node_group_name
#     cluster_name    = aws_eks_node_group.private-nodes.cluster_name
#     node_role_arn   = aws_eks_node_group.private-nodes.node_role_arn
#     status          = aws_eks_node_group.private-nodes.status
#   }
# }