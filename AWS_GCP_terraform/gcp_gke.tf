resource "google_container_cluster" "nginxweb_cluster" {
  name               = "nginxweb"
  location           = "asia-northeast3"
  node_locations     = ["asia-northeast3-b", "asia-northeast3-c"]

  initial_node_count = 2

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

  node_config {
    machine_type  = "e2-medium"
    disk_size_gb  = 50   
    disk_type    = "pd-ssd"      
    oauth_scopes  = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "Allow all IPs"
    }
  }

  deletion_protection = false
}

resource "null_resource" "helm_install_gcp" {
  provisioner "local-exec" {
    command = <<-EOT
      powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 -OutFile 'get-helm.ps1'; .\get-helm.ps1"
    EOT
  }
}

resource "null_resource" "helm_deploy_nginx" {
  provisioner "local-exec" {
    command = <<-EOT
      set PATH=%PATH%;C:\Program Files\Helm
      helm upgrade --install nginx-release ./nginxweb-deployment.yaml
    EOT
  }
  
  depends_on = [google_container_cluster.nginxweb_cluster, null_resource.helm_install_gcp]
}
