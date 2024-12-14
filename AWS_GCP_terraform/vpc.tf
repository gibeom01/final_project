resource "aws_vpc" "SEC-PRD-VPC" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.SEC-PRD-VPC.id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name    = "${var.vpc_name}-IGW"
    Project = var.pnoun
  }

  depends_on = [aws_subnet.PUB-2A]
}

resource "aws_eip" "SEC-PRD-NAT-EIP-2A" {
  domain = "vpc"
  tags = {
    Name    = "${var.vpc_name}-EIP-2A"
    Project = var.pnoun
  }
}

resource "aws_eip" "SEC-PRD-NAT-EIP-2C" {
  domain = "vpc"
  tags = {
    Name    = "${var.vpc_name}-EIP-2C"
    Project = var.pnoun
  }
}

resource "aws_nat_gateway" "NGW-2A" {
  allocation_id = aws_eip.SEC-PRD-NAT-EIP-2A.id
  subnet_id     = aws_subnet.PUB-2A.id
  tags = {
    Name    = "${var.vpc_name}-NGW-2A"
    Project = var.pnoun
  }

  depends_on = [aws_subnet.PRI-2A]
}

resource "aws_nat_gateway" "NGW-2C" {
  allocation_id = aws_eip.SEC-PRD-NAT-EIP-2C.id
  subnet_id     = aws_subnet.PUB-2C.id
  tags = {
    Name    = "${var.vpc_name}-NGW-2C"
    Project = var.pnoun
  }

  depends_on = [aws_subnet.PRI-2C]
}

resource "aws_subnet" "PUB-2A" {
  cidr_block           = var.sub_cidr[0]
  vpc_id               = aws_vpc.SEC-PRD-VPC.id
  availability_zone    = var.azs[0]
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.vpc_name}-PUB-2A"
    Project = var.pnoun
  }

  depends_on = [aws_vpc.SEC-PRD-VPC]
}

resource "aws_subnet" "PUB-2C" {
  cidr_block           = var.sub_cidr[1]
  vpc_id               = aws_vpc.SEC-PRD-VPC.id
  availability_zone    = var.azs[1]
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.vpc_name}-PUB-2C"
    Project = var.pnoun
  }

  depends_on = [aws_vpc.SEC-PRD-VPC]
}

resource "aws_subnet" "PRI-2A" {
  cidr_block        = var.sub_cidr[2]
  vpc_id            = aws_vpc.SEC-PRD-VPC.id
  availability_zone = var.azs[0]
  tags = {
    Name    = "${var.vpc_name}-PRI-2A"
    Project = var.pnoun
  }

  depends_on = [aws_vpc.SEC-PRD-VPC]
}

resource "aws_subnet" "PRI-2C" {
  cidr_block        = var.sub_cidr[3]
  vpc_id            = aws_vpc.SEC-PRD-VPC.id
  availability_zone = var.azs[1]
  tags = {
    Name    = "${var.vpc_name}-PRI-2C"
    Project = var.pnoun
  }
  
  depends_on = [aws_vpc.SEC-PRD-VPC]
}

resource "aws_subnet" "PRI-RDS-2A" {
  cidr_block        = var.sub_cidr[4]
  vpc_id            = aws_vpc.SEC-PRD-VPC.id
  availability_zone = var.azs[0]
  tags = {
    Name    = "${var.vpc_name}-PRI-RDS-2A"
    Project = var.pnoun
  }

  depends_on = [aws_vpc.SEC-PRD-VPC]
}

resource "aws_subnet" "PRI-RDS-2C" {
  cidr_block        = var.sub_cidr[5]
  vpc_id            = aws_vpc.SEC-PRD-VPC.id
  availability_zone = var.azs[1]
  tags = {
    Name    = "${var.vpc_name}-PRI-RDS-2C"
    Project = var.pnoun
  }

  depends_on = [aws_vpc.SEC-PRD-VPC]
}

resource "aws_route_table" "RT-PUB" {
  vpc_id = aws_vpc.SEC-PRD-VPC.id
  tags = {
    Name    = "${var.vpc_name}-RT-PUB"
    Project = var.pnoun
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  depends_on = [aws_internet_gateway.IGW]
}

resource "aws_route_table" "RT-PRI-2A" {
  vpc_id = aws_vpc.SEC-PRD-VPC.id
  tags = {
    Name    = "${var.vpc_name}-RT-PRI-2A"
    Project = var.pnoun
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NGW-2A.id
  }

  depends_on = [aws_nat_gateway.NGW-2A]
}

resource "aws_route_table" "RT-PRI-2C" {
  vpc_id = aws_vpc.SEC-PRD-VPC.id
  tags = {
    Name    = "${var.vpc_name}-RT-PRI-2C"
    Project = var.pnoun
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NGW-2C.id
  }

  depends_on = [aws_nat_gateway.NGW-2A]
}

resource "aws_route_table_association" "PUB-2A" {
  subnet_id      = aws_subnet.PUB-2A.id
  route_table_id = aws_route_table.RT-PUB.id
}

resource "aws_route_table_association" "PUB-2C" {
  subnet_id      = aws_subnet.PUB-2C.id
  route_table_id = aws_route_table.RT-PUB.id
}

resource "aws_route_table_association" "PRI-2A" {
  subnet_id      = aws_subnet.PRI-2A.id
  route_table_id = aws_route_table.RT-PRI-2A.id
}

resource "aws_route_table_association" "PRI-2C" {
  subnet_id      = aws_subnet.PRI-2C.id
  route_table_id = aws_route_table.RT-PRI-2C.id
}

resource "aws_route_table_association" "PRI-RDS-2A" {
  subnet_id      = aws_subnet.PRI-RDS-2A.id
  route_table_id = aws_route_table.RT-PRI-2A.id
}

resource "aws_route_table_association" "PRI-RDS-2C" {
  subnet_id      = aws_subnet.PRI-RDS-2C.id
  route_table_id = aws_route_table.RT-PRI-2C.id
}
