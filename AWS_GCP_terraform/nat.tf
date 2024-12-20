resource "aws_eip" "nat_gateway_eip" {
  count = length(var.azs)
  domain = "vpc"
  tags = {
    Name    = "${var.vpc_name}-EIP-${element(var.azs, count.index)}"
    Project = var.pnoun
  }
}

resource "aws_nat_gateway" "NGW" {
  count = length(var.azs)
  allocation_id = aws_eip.nat_gateway_eip[count.index].id
  subnet_id     = element([aws_subnet.PUB-2A.id, aws_subnet.PUB-2C.id], count.index)
  tags = {
    Name    = "${var.vpc_name}-NGW-${element(var.azs, count.index)}"
    Project = var.pnoun
  }
}
