resource "aws_vpc" "vpc" {
  cidr_block         = "10.0.0.0/16"
  enable_dns_support = true
}

resource "aws_subnet" "commander_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "commander_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
}

# Virtual private cloud configuration
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "commander_rt_a" {
  subnet_id      = aws_subnet.commander_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "commander_rt_b" {
  subnet_id      = aws_subnet.commander_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}