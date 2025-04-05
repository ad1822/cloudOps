resource "aws_eip" "nat" {
  # vpc = Enable

  tags = {
    Name = "nat"
  }
}


resource "aws_nat_gateway" "k8s-nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet-ap-south-1a.id

  tags = {
    Name = "k8s-nat"
  }

  depends_on = [aws_internet_gateway.k8svpc-igw]
}