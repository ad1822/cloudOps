resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.k8s_cluster.name
  node_group_name = "private-node"
  node_role_arn   = aws_iam_role.nodes.arn


  subnet_ids = [
    aws_subnet.private-subnet-ap-south-1a.id,
    aws_subnet.private-subnet-ap-south-1b.id
    # aws_subnet.public-subnet-ap-south-1a.id,
    # aws_subnet.public-subnet-ap-south-1b.id
  ]


  # node_security_group_id = aws_security_group.eks_nodes.id
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 10
    min_size     = 0
  }


  tags = {
    Name                             = "private-nodegroup"
    Environment                      = "dev"
    "kubernetes.io/cluster/demo-eks" = "owned"
  }


  update_config {
    max_unavailable = 1
  }


  labels = {
    node = "kubenode02"
  }
  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}


resource "aws_security_group" "eks_nodes" {
  name        = "eks-node-sg-eks"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.k8s-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                           = "eks-node-sg"
    "kubernetes.io/cluster/demo-eks" = "owned"
  }
}

resource "aws_security_group_rule" "nodes_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  type                     = "ingress"
}

# Allow pods to communicate with cluster API
resource "aws_security_group_rule" "nodes_cluster_egress" {
  description              = "Allow nodes to egress to cluster API"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_eks_cluster.k8s_cluster.vpc_config[0].cluster_security_group_id
  type                     = "egress"
}

resource "aws_security_group_rule" "cluster_ingress_nodes" {
  description              = "Allow worker nodes to communicate with cluster API"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.k8s_cluster.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.eks_nodes.id
}