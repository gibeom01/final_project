resource "aws_vpn_gateway" "VGW-FOR-GCP" {
  vpc_id = aws_vpc.SEC-PRD-VPC.id

  tags = {
    Name = "VGW-FOR-GCP"
  }
}

resource "aws_customer_gateway" "CGW-FOR-GCP-0" {
  bgp_asn    = "65000"
  ip_address = google_compute_ha_vpn_gateway.ha-gateway.vpn_interfaces.0.ip_address
  type       = "ipsec.1"

  tags = {
    Name = "CGW-FOR-GCP-0"
  }
}

resource "aws_customer_gateway" "CGW-FOR-GCP-1" {
  bgp_asn    = "65000"
  ip_address = google_compute_ha_vpn_gateway.ha-gateway.vpn_interfaces.1.ip_address
  type       = "ipsec.1"

  tags = {
    Name = "CGW-FOR-GCP-1"
  }
}

resource "aws_vpn_gateway_route_propagation" "testing_route" {
  route_table_id = aws_route_table.RT-PUB.id
  vpn_gateway_id = aws_vpn_gateway.VGW-FOR-GCP.id
}

resource "aws_vpn_gateway_route_propagation" "testing_route1" {
    route_table_id = aws_route_table.RT-PRI-2A.id
    vpn_gateway_id = aws_vpn_gateway.VGW-FOR-GCP.id
}

resource "aws_vpn_gateway_route_propagation" "testing_route2" {
  route_table_id = aws_route_table.RT-PRI-2A.id
  vpn_gateway_id = aws_vpn_gateway.VGW-FOR-GCP.id
}

resource "aws_vpn_connection" "AWS-GCP-VPN-0" {
  customer_gateway_id = aws_customer_gateway.CGW-FOR-GCP-0.id
  vpn_gateway_id      = aws_vpn_gateway.VGW-FOR-GCP.id
  type                = "ipsec.1"
  static_routes_only  = false
  local_ipv4_network_cidr = "10.0.30.0/24"
  remote_ipv4_network_cidr = "10.0.80.0/21"
  tunnel1_ike_versions = ["ikev2"]
  tunnel2_ike_versions = ["ikev2"]

  tags = {
    Name = "AWS-GCP-VPN-0"
  }
}

resource "aws_vpn_connection" "AWS-GCP-VPN-1" {
  customer_gateway_id = aws_customer_gateway.CGW-FOR-GCP-1.id
  vpn_gateway_id      = aws_vpn_gateway.VGW-FOR-GCP.id
  type                = "ipsec.1"
  static_routes_only  = false
  local_ipv4_network_cidr = "10.0.40.0/24"
  remote_ipv4_network_cidr = "10.0.80.0/21"
  tunnel1_ike_versions = ["ikev2"]
  tunnel2_ike_versions = ["ikev2"]

  tags = {
    Name = "AWS-GCP-VPN-1"
  }
}
