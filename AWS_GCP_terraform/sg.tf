resource "aws_security_group" "PUB-SG" {
  vpc_id      = aws_vpc.SEC-PRD-VPC.id
  name        = var.pub_sg
  description = "Allow traffic for VPN and HTTP services"

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = [
      "172.16.0.0/28",
      "192.168.70.0/24",
      "192.168.80.0/21",
      "192.168.90.0/24",
      "192.168.72.0/22",
      "192.168.76.0/24",
      "192.168.120.0/22",
      "192.168.140.0/22",
      "192.168.92.0/22",
      "192.168.96.0/24"
      ]
    description = "Allow IPsec VPN (UDP 500)"
  }
  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = [
      "172.16.0.0/28",
      "192.168.70.0/24",
      "192.168.80.0/21",
      "192.168.90.0/24",
      "192.168.72.0/22",
      "192.168.76.0/24",
      "192.168.120.0/22",
      "192.168.140.0/22",
      "192.168.92.0/22",
      "192.168.96.0/24"
      ]
    description = "Allow NAT-T VPN (UDP 4500)"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "51"
    cidr_blocks = [
      "172.16.0.0/28",
      "192.168.70.0/24",
      "192.168.80.0/21",
      "192.168.90.0/24",
      "192.168.72.0/22",
      "192.168.76.0/24",
      "192.168.120.0/22",
      "192.168.140.0/22",
      "192.168.92.0/22",
      "192.168.96.0/24"
      ]
    description = "Allow ESP (Encapsulating Security Payload)"
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [
      "172.16.0.0/28",
      "192.168.70.0/24",
      "192.168.80.0/21",
      "192.168.90.0/24",
      "192.168.72.0/22",
      "192.168.76.0/24",
      "192.168.120.0/22",
      "192.168.140.0/22",
      "192.168.92.0/22",
      "192.168.96.0/24"
      ] 
    description = "Allow ICMP from GCP networks"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from admin IP range"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP on port 8080"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "PUB-SG"
  }

  depends_on = [aws_internet_gateway.IGW]
}

resource "aws_security_group" "PRI-SG" {
  vpc_id = aws_vpc.SEC-PRD-VPC.id
  name   = var.pri_sg
  description = "Allow traffic for private subnet"

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = [
      "172.16.0.0/28",
      "192.168.70.0/24",
      "192.168.80.0/21",
      "192.168.90.0/24",
      "192.168.72.0/22",
      "192.168.76.0/24",
      "192.168.120.0/22",
      "192.168.140.0/22",
      "192.168.92.0/22",
      "192.168.96.0/24"
      ]   
    description = "Allow IPsec VPN (UDP 500)"
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = [
      "172.16.0.0/28",
      "192.168.70.0/24",
      "192.168.80.0/21",
      "192.168.90.0/24",
      "192.168.72.0/22",
      "192.168.76.0/24",
      "192.168.120.0/22",
      "192.168.140.0/22",
      "192.168.92.0/22",
      "192.168.96.0/24"
      ]
    description = "Allow NAT-T VPN (UDP 4500)"
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "51"
    cidr_blocks = [
      "172.16.0.0/28",
      "192.168.70.0/24",
      "192.168.80.0/21",
      "192.168.90.0/24",
      "192.168.72.0/22",
      "192.168.76.0/24",
      "192.168.120.0/22",
      "192.168.140.0/22",
      "192.168.92.0/22",
      "192.168.96.0/24"
      ]
    description = "Allow AH (Authentication Header) for IPsec"
  }

  ingress {
    from_port = 8
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks = [
      "172.16.0.0/28",
      "192.168.70.0/24",
      "192.168.80.0/21",
      "192.168.90.0/24",
      "192.168.72.0/22",
      "192.168.76.0/24",
      "192.168.120.0/22",
      "192.168.140.0/22",
      "192.168.92.0/22",
      "192.168.96.0/24"
      ]
    description = "Allow ICMP echo requests from VPC"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.PUB-SG.id]
    description = "Allow SSH from Bastion Host"
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
    description = "Allow HTTP traffic to Tomcat (port 8080)"
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow secure communication to EKS API server (TCP 443)"
  }

  ingress {
    from_port = 1025
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow node-to-node communication (TCP 1025-65535)"
  }

  ingress {
    from_port = 53
    to_port   = 53
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow DNS communication (TCP 53)"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PRI-SG"
  }

  depends_on = [aws_nat_gateway.NGW]
}

resource "aws_security_group" "PRI-RDS-SG" {
  vpc_id      = aws_vpc.SEC-PRD-VPC.id
  name        = var.pri_rds_sg
  description = "Allow MySQL traffic to RDS"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow MySQL from within VPC"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [aws_security_group.PUB-SG.id]
    description     = "Allow SSH from Bastion Host (if required)"
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow secure communication to EKS API server (TCP 443)"
  }

  ingress {
    from_port = 1025
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow node-to-node communication (TCP 1025-65535)"
  }

  ingress {
    from_port = 53
    to_port   = 53
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow DNS communication (TCP 53)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    name = "PRI-RDS-SG"
  }

  depends_on = [aws_nat_gateway.NGW]
}
