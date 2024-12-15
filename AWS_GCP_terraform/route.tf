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
    nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
  }

  depends_on = [aws_nat_gateway.nat_gateway]
}

resource "aws_route_table" "RT-PRI-2C" {
  vpc_id = aws_vpc.SEC-PRD-VPC.id
  tags = {
    Name    = "${var.vpc_name}-RT-PRI-2C"
    Project = var.pnoun
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[1].id
  }

  depends_on = [aws_nat_gateway.nat_gateway]
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
