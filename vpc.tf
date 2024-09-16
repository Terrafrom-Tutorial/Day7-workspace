resource "aws_vpc" "VPC" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_Name
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = var.igw_name
}
}

resource "aws_subnet" "pub_subnet" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = var.subnet_cidr
    tags = {
      Name = var.subnet_Name
    }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.VPC.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = var.rtp_Name
  }
}

resource "aws_route_table_association" "pub_rtb_asso" {
  route_table_id = aws_route_table.public_rtb.id
  subnet_id = aws_subnet.pub_subnet.id
}