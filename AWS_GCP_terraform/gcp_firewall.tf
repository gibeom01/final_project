resource "google_compute_firewall" "allow" {
  name    = "allow-resources"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["443", "80", "22"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow"]
  description   = "Allow HTTPS traffic from anywhere"
}

resource "google_compute_firewall" "vpn" {
  name    = "allow-vpn-traffic"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "udp"
    ports    = ["500", "4500"]
  }

  allow {
    protocol = "esp"
  }

  source_ranges = ["10.0.0.0/16"]
  target_tags   = ["vpn"]
  description   = "Allow VPN traffic for IPsec, NAT-T, and ESP"
}

resource "google_compute_firewall" "gke" {
  name    = "gke-traffic"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "80", "8080", "3306", "1025-65535", "53"]
  }

  allow {
    protocol = "udp"
    ports    = ["53"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
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
  target_tags   = ["gke"]
  description   = "Allow internal VPC traffic for specified ranges"
}
