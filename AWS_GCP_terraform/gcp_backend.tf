resource "google_compute_backend_service" "gke_backend_service" {
  name     = "gke-backend-service"
  protocol = "HTTP"

  backend {
    group            = google_compute_instance_group.gke_instance_group.self_link
    balancing_mode   = "RATE"
    max_rate         = 1000
  }

  timeout_sec = 10

  health_checks = [google_compute_health_check.gke_health_check.self_link]
}

resource "google_compute_network_endpoint_group" "gke_neg" {
  name       = "gke-neg"
  network    = google_compute_network.vpc_network.self_link
  subnetwork = google_compute_subnetwork.GCP_PRI_A.self_link
  default_port = 80
  zone       = "asia-northeast3-a"
}

resource "google_compute_instance_group" "gke_instance_group" {
  name        = "gke-instance-group"
  zone        = "asia-northeast1-a"
  instances   = [for instance in google_compute_instance.gke_instances : instance.self_link]

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_instance" "gke_instances" {
  count        = 3
  name         = "gke-instance-${count.index}"
  machine_type = "n1-standard-1"
  zone         = "asia-northeast1-a"

  boot_disk {
    initialize_params {
      image = "debian-9-stretch-v20181011"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_compute_health_check" "gke_health_check" {
  name = "gke-health-check"

  http_health_check {
    port               = 80
    request_path       = "/healthz"
  }
}
