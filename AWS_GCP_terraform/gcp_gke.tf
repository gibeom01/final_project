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

resource "null_resource" "install_helm_nginxweb" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "Downloading Helm install script..."
      curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

      echo "Making the Helm install script executable..."
      sudo chmod +x ./helm/get_helm.sh

      echo "Installing Helm..."
      ./helm/get_helm.sh

      echo "Updating kubeconfig for GKE cluster..."
      gcloud container clusters get-credentials nginxweb --zone asia-northeast3 --project deep-thought-440807-g3
      
      echo "Deploying Helm chart..."
      helm upgrade --install nginx-release ./helm/nginxweb --namespace web-apps --create-namespace
      
      echo "Helm installation and deployment completed successfully!"
    EOT

    environment = {
      KUBECONFIG = "/home/ubuntu/.kube/config"
    }

    working_dir = "${path.module}/helm"
  }

  depends_on = [
    null_resource.install_helm_tomcatwas,
    google_container_cluster.nginxweb_cluster
    ]
}
