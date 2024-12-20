resource "aws_vpn_gateway" "AWS-VPN-GW" {
  vpc_id = aws_vpc.SEC-PRD-VPC.id

  tags = {
    Name = "AWS-VPN-GW"
  }
}

resource "aws_customer_gateway" "AWS-CGW-GCP-0" {
  bgp_asn    = "65000"
  ip_address = google_compute_ha_vpn_gateway.gcp-vpn-gw.vpn_interfaces.0.ip_address
  type       = "ipsec.1"

  tags = {
    Name = "AWS-CGW-GCP-0"
  }
}

resource "aws_customer_gateway" "AWS-CGW-GCP-1" {
  bgp_asn    = "65000"
  ip_address = google_compute_ha_vpn_gateway.gcp-vpn-gw.vpn_interfaces.1.ip_address
  type       = "ipsec.1"

  tags = {
    Name = "AWS-CGW-GCP-1"
  }
}

resource "aws_vpn_gateway_route_propagation" "testing_route" {
  route_table_id = aws_route_table.RT-PUB.id
  vpn_gateway_id = aws_vpn_gateway.AWS-VPN-GW.id
}

resource "aws_vpn_gateway_route_propagation" "testing_route1" {
    route_table_id = aws_route_table.RT-PRI-2A.id
    vpn_gateway_id = aws_vpn_gateway.AWS-VPN-GW.id
}

resource "aws_vpn_gateway_route_propagation" "testing_route2" {
  route_table_id = aws_route_table.RT-PRI-2C.id
  vpn_gateway_id = aws_vpn_gateway.AWS-VPN-GW.id
}

resource "aws_vpn_connection" "VPNCON-AWS-GCP-0" {
  customer_gateway_id = aws_customer_gateway.AWS-CGW-GCP-0.id
  vpn_gateway_id      = aws_vpn_gateway.AWS-VPN-GW.id
  type                = "ipsec.1"
  static_routes_only  = false
  local_ipv4_network_cidr = "10.0.0.0/16"
  remote_ipv4_network_cidr = "192.168.70.0/24"
  tunnel1_ike_versions = ["ikev2"]
  tunnel2_ike_versions = ["ikev2"]

  tags = {
    Name = "VPNCON-AWS-GCP-0"
  }
}

resource "aws_vpn_connection" "VPNCON-AWS-GCP-1" {
  customer_gateway_id = aws_customer_gateway.AWS-CGW-GCP-1.id
  vpn_gateway_id      = aws_vpn_gateway.AWS-VPN-GW.id
  type                = "ipsec.1"
  static_routes_only  = false
  local_ipv4_network_cidr = "10.0.0.0/16"
  remote_ipv4_network_cidr = "192.168.70.0/24"
  tunnel1_ike_versions = ["ikev2"]
  tunnel2_ike_versions = ["ikev2"]

  tags = {
    Name = "VPNCON-AWS-GCP-1"
  }
}
