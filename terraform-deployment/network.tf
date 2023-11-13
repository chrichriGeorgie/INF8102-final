resource "aws_vpc" "vpc" {
  cidr_block         = "10.0.0.0/16"
  enable_dns_support = true
}

resource "aws_subnet" "commander_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/24"
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

resource "aws_route_table_association" "commander_rt" {
  subnet_id      = aws_subnet.commander_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "commander_sg" {
  name   = "Commander Security Group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = var.application_port
    to_port     = var.docker_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}