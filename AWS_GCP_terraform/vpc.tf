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
