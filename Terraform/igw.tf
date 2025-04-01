resource "aws_internet_gateway" "k8svpc-igw" {
  vpc_id = aws_vpc.k8s-vpc.id

  tags = {
    Name = "k8svpc-igw"
  }
}