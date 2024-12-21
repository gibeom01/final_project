provider "google" {
  credentials = file("${path.module}/gcp_project.json")
  project     = var.gcp_project_id
  region      = "asia-northeast3"
}

resource "google_compute_instance" "bastion_host" {
  name         = "bastion-host"
  machine_type = "e2-small"
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = var.gcp_ubuntu_image
      size  = 10
      type  = "pd-standard"
    }
  }

  metadata_startup_script = file("${path.module}/user_data_gcp_bastion.sh")

  network_interface {
    network    = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.GCP_PUB.self_link
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArJQ9...(생략)...key1 ubuntu"
  }

  tags = [
    "allow",
    "vpn"
    ]

  service_account {
    email  = var.gcp_service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
