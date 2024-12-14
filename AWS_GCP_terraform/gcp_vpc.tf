resource "google_compute_network" "vpc_network" {
  name                    = "project-vpc"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "GCP_PUB" {
  name                     = "gcp-pub"
  ip_cidr_range            = "10.0.70.0/24"
  region                   = "asia-northeast3"
  network                  = google_compute_network.vpc_network.name
  private_ip_google_access = true

  dynamic "secondary_ip_range" {
    for_each = [
      { range_name = "pub-nginxweb-pods", ip_cidr_range = "10.0.72.0/22" },
      { range_name = "pub-nginxweb-services", ip_cidr_range = "10.0.76.0/24" }
    ]
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}

resource "google_compute_subnetwork" "GCP_PRI_A" {
  name                     = "gcp-pri-a"
  ip_cidr_range            = "10.0.80.0/21"
  region                   = "asia-northeast3"
  network                  = google_compute_network.vpc_network.name
  private_ip_google_access = true

  dynamic "secondary_ip_range" {
    for_each = [
      { range_name = "pri-a-nginxweb-pods", ip_cidr_range = "10.0.120.0/22" },
      { range_name = "pri-a-nginxweb-services", ip_cidr_range = "10.0.140.0/22" }
    ]
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}

resource "google_compute_subnetwork" "GCP_PRI_C" {
  name                     = "gcp-pri-c"
  ip_cidr_range            = "10.0.90.0/24"
  region                   = "asia-northeast3"
  network                  = google_compute_network.vpc_network.name
  private_ip_google_access = true

  dynamic "secondary_ip_range" {
    for_each = [
      { range_name = "pri-c-nginxweb-pods", ip_cidr_range = "10.0.92.0/22" },
      { range_name = "pri-c-nginxweb-services", ip_cidr_range = "10.0.96.0/24" }
    ]
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}
