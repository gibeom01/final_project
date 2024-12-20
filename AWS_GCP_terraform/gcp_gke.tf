resource "google_container_cluster" "nginxweb_cluster" {
  name               = "nginxweb"
  location           = "asia-northeast3"
  node_locations     = ["asia-northeast3-b", "asia-northeast3-c"]

  initial_node_count = 1

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.GCP_PRI_A.name

  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = "172.16.0.0/28"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pri-a-nginxweb-pods"
    services_secondary_range_name = "pri-a-nginxweb-services"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "Allow all IPs"
    }
  }

  deletion_protection = false
}

resource "google_container_node_pool" "nginxweb_node_pool" {
  name       = "node-pool"
  cluster    = google_container_cluster.nginxweb_cluster.name
  location   = google_container_cluster.nginxweb_cluster.location

  node_config {
    machine_type = "e2-medium"
    tags         = [
      "vpn",
      "gke"
      ]
    disk_size_gb = 30
    disk_type    = "pd-ssd"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    labels = {
      env  = "prod"
      role = "webserver"
    }
  }

  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 2
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }

  node_locations = google_container_cluster.nginxweb_cluster.node_locations
}
