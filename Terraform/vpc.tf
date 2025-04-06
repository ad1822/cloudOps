
# VPC
resource "aws_vpc" "k8s-vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "k8s-vpc"
  }
}

# Private Subnets 01
resource "aws_subnet" "private-subnet-ap-south-1a" {
  vpc_id            = aws_vpc.k8s-vpc.id
  cidr_block        = "192.168.0.0/19"
  availability_zone = "ap-south-1a"

  tags = {
    Name                              = "private-ap-south-1a"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo-eks"  = "owned"
  }
}

# Private Subnets 02
resource "aws_subnet" "private-subnet-ap-south-1b" {
  vpc_id            = aws_vpc.k8s-vpc.id
  cidr_block        = "192.168.32.0/19"
  availability_zone = "ap-south-1b"

  tags = {
    Name                              = "private-ap-south-1b"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo-eks"  = "owned"
  }
}

# Public Subnet 01

resource "aws_subnet" "public-subnet-ap-south-1a" {
  vpc_id                  = aws_vpc.k8s-vpc.id
  cidr_block              = "192.168.64.0/19"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                             = "public-ap-south-1a"
    "kubernetes.io/role/elb"         = "1"
    "kubernetes.io/cluster/demo-eks" = "owned"
  }
}

resource "aws_subnet" "public-subnet-ap-south-1b" {
  vpc_id                  = aws_vpc.k8s-vpc.id
  cidr_block              = "192.168.96.0/19"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                             = "public-ap-south-1b"
    "kubernetes.io/role/elb"         = "1"
    "kubernetes.io/cluster/demo-eks" = "owned"
  }
}
