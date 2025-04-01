resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.k8s-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.k8s-nat.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.k8s-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8svpc-igw.id
  }

  tags = {
    Name = "public"
  }
}


resource "aws_route_table_association" "private-ap-south-1a" {
  subnet_id      = aws_subnet.private-subnet-ap-south-1a.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "private-ap-south-1b" {
  subnet_id      = aws_subnet.private-subnet-ap-south-1b.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "public-ap-south-1a" {
  subnet_id      = aws_subnet.public-subnet-ap-south-1a.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-ap-south-1b" {
  subnet_id      = aws_subnet.public-subnet-ap-south-1b.id
  route_table_id = aws_route_table.public-route-table.id
}