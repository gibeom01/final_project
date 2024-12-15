resource "aws_security_group" "PUB-SG" {
  vpc_id      = aws_vpc.SEC-PRD-VPC.id
  name = var.pub_sg
  description = "Allow HTTP and HTTPS traffic to Bastion"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from anywhere"
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ICMP from anywhere"
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow 8080 from anywhere"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    name = "PUB-SG"
  }

  depends_on = [aws_internet_gateway.IGW]
}

resource "aws_security_group" "PRI-SG" {
  vpc_id      = aws_vpc.SEC-PRD-VPC.id
  name = var.pri_sg
  description = "Allow HTTP traffic to Tomcat"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.PUB-SG.id]
    description = "Allow SSH from Bastion Host"
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  ingress {
    from_port = -1 
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "ICMP from VPC"
  }

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "MySQL/Aurora from VPC"
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "8080 from VPC"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "PRI-SG"
  }

  depends_on = [aws_nat_gateway.nat_gateway]
}

resource "aws_security_group" "PRI-RDS-SG" {
  vpc_id      = aws_vpc.SEC-PRD-VPC.id
  name = var.pri_rds_sg
  description = "Allow HTTP traffic to MySQL"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.PUB-SG.id]
    description = "Allow SSH from Bastion Host"
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "ICMP from VPC"
  }

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "MySQL/Aurora from VPC"
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "8080 from VPC"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "PRI-RDS-SG"
  }

  depends_on = [aws_nat_gateway.nat_gateway]
}
