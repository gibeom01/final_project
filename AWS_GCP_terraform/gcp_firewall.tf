resource "google_compute_firewall" "allow_bastion_ssh" {
  name    = "allow-bastion-ssh"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
  description   = "Allow SSH, HTTP, HTTPS, ICMP, and 8080 traffic from anywhere"
}
