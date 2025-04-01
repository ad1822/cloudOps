resource "aws_vpc" "k8s-vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "k8s-vpc"
  }
}