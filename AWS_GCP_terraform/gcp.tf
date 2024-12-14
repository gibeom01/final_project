provider "google" {
  credentials = file("gcp_project.json")
  project     = "deep-thought-440807-g3"
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

  metadata_startup_script = templatefile("${path.module}/user_data_gcp_bastion.sh", {
    private_key = filebase64("${path.module}/gcp_project.json")
  })

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.GCP_PUB.id
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArJQ9...(생략)...key1 ubuntu"
  }

  tags = ["bastion"]

  service_account {
    email  = var.gcp_service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
