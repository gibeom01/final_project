resource "google_compute_router" "gcp-router" {
  name    = "gcp-router"
  region  = "asia-northeast3"
  network = google_compute_network.vpc_network.id

  bgp {
    asn               = 65000
    }
  
}

resource "google_compute_ha_vpn_gateway" "gcp-vpn-gw" {
  region  = "asia-northeast3"
  name    = "gcp-vpn-gw"
  network = google_compute_network.vpc_network.id
}

resource "google_compute_external_vpn_gateway" "peer-gcp-aws" {
  name            = "peer-gcp-aws"
  redundancy_type = "FOUR_IPS_REDUNDANCY"
  interface {
    id        = 0
    ip_address = aws_vpn_connection.VPNCON-AWS-GCP-0.tunnel1_address
  }
  interface {
    id        = 1
    ip_address = aws_vpn_connection.VPNCON-AWS-GCP-0.tunnel2_address
  }
  interface {
    id        = 2
    ip_address = aws_vpn_connection.VPNCON-AWS-GCP-1.tunnel1_address
  }
  interface {
    id        = 3
    ip_address = aws_vpn_connection.VPNCON-AWS-GCP-1.tunnel2_address
  }
}

resource "google_compute_vpn_tunnel" "tunnel1" {
  name                         = "ha-vpn-tunnel1"
  region                       = "asia-northeast3"
  vpn_gateway                  = google_compute_ha_vpn_gateway.gcp-vpn-gw.id
  peer_external_gateway        = google_compute_external_vpn_gateway.peer-gcp-aws.id
  peer_external_gateway_interface = 0
  shared_secret                = aws_vpn_connection.VPNCON-AWS-GCP-0.tunnel1_preshared_key
  router                       = google_compute_router.gcp-router.id
  vpn_gateway_interface        = 0
}

resource "google_compute_vpn_tunnel" "tunnel2" {
  name                         = "ha-vpn-tunnel2"
  region                       = "asia-northeast3"
  vpn_gateway                  = google_compute_ha_vpn_gateway.gcp-vpn-gw.id
  peer_external_gateway        = google_compute_external_vpn_gateway.peer-gcp-aws.id
  peer_external_gateway_interface = 1
  shared_secret                = aws_vpn_connection.VPNCON-AWS-GCP-0.tunnel2_preshared_key
  router                       = google_compute_router.gcp-router.id
  vpn_gateway_interface        = 0
}

resource "google_compute_vpn_tunnel" "tunnel3" {
  name                         = "ha-vpn-tunnel3"
  region                       = "asia-northeast3"
  vpn_gateway                  = google_compute_ha_vpn_gateway.gcp-vpn-gw.id
  peer_external_gateway        = google_compute_external_vpn_gateway.peer-gcp-aws.id
  peer_external_gateway_interface = 2
  shared_secret                = aws_vpn_connection.VPNCON-AWS-GCP-1.tunnel1_preshared_key
  router                       = google_compute_router.gcp-router.id
  vpn_gateway_interface        = 1
}

resource "google_compute_vpn_tunnel" "tunnel4" {
  name                         = "ha-vpn-tunnel4"
  region                       = "asia-northeast3"
  vpn_gateway                  = google_compute_ha_vpn_gateway.gcp-vpn-gw.id
  peer_external_gateway        = google_compute_external_vpn_gateway.peer-gcp-aws.id
  peer_external_gateway_interface = 3
  shared_secret                = aws_vpn_connection.VPNCON-AWS-GCP-1.tunnel2_preshared_key
  router                       = google_compute_router.gcp-router.id
  vpn_gateway_interface        = 1
}

resource "google_compute_router_interface" "router-interface1" {
  name     = "router-interface1"
  router   = google_compute_router.gcp-router.name
  region   = "asia-northeast3"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel1.name
}

resource "google_compute_router_peer" "route-peer1" {
  name              = "route-peer1"
  router            = google_compute_router.gcp-router.name
  region            = "asia-northeast3"
  ip_address        = aws_vpn_connection.VPNCON-AWS-GCP-0.tunnel1_cgw_inside_address
  peer_ip_address   = aws_vpn_connection.VPNCON-AWS-GCP-0.tunnel1_vgw_inside_address
  peer_asn          = 64512
  interface         = google_compute_router_interface.router-interface1.name
}

resource "google_compute_router_interface" "router-interface2" {
  name     = "router-interface2"
  router   = google_compute_router.gcp-router.name
  region   = "asia-northeast3"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel2.name
}

resource "google_compute_router_peer" "route-peer2" {
  name              = "route-peer2"
  router            = google_compute_router.gcp-router.name
  region            = "asia-northeast3"
  ip_address        = aws_vpn_connection.VPNCON-AWS-GCP-0.tunnel2_cgw_inside_address
  peer_ip_address   = aws_vpn_connection.VPNCON-AWS-GCP-0.tunnel2_vgw_inside_address
  peer_asn          = 64512
  interface         = google_compute_router_interface.router-interface2.name
}

resource "google_compute_router_interface" "router-interface3" {
  name     = "router-interface3"
  router   = google_compute_router.gcp-router.name
  region   = "asia-northeast3"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel3.name
}

resource "google_compute_router_peer" "route-peer3" {
  name              = "route-peer3"
  router            = google_compute_router.gcp-router.name
  region            = "asia-northeast3"
  ip_address        = aws_vpn_connection.VPNCON-AWS-GCP-1.tunnel1_cgw_inside_address
  peer_ip_address   = aws_vpn_connection.VPNCON-AWS-GCP-1.tunnel1_vgw_inside_address
  peer_asn          = 64512
  interface         = google_compute_router_interface.router-interface3.name
}

resource "google_compute_router_interface" "router-interface4" {
  name     = "router-interface4"
  router   = google_compute_router.gcp-router.name
  region   = "asia-northeast3"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel4.name
}

resource "google_compute_router_peer" "route-peer4" {
  name              = "route-peer4"
  router            = google_compute_router.gcp-router.name
  region            = "asia-northeast3"
  ip_address        = aws_vpn_connection.VPNCON-AWS-GCP-1.tunnel2_cgw_inside_address
  peer_ip_address   = aws_vpn_connection.VPNCON-AWS-GCP-1.tunnel2_vgw_inside_address
  peer_asn          = 64512
  interface         = google_compute_router_interface.router-interface4.name
}
