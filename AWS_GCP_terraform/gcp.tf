provider "google" { 
  credentials = file("${path.module}/gcp_project.json")
  project     = "deep-thought-440807-g3"
  region      = var.gcp_region
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
    ssh-keys = <<EOT
ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArJQ9...(생략)...key1 ubuntu
EOT
  }

  tags = ["bastion"]

  service_account {
    email  = var.gcp_service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

# 변수 파일 참고 예제
variable "gcp_region" {
  default = "asia-northeast3"
  description = "GCP 리전 설정"
}

variable "gcp_zone" {
  default = "asia-northeast3-a"
  description = "GCP 존 설정"
}

variable "gcp_ubuntu_image" {
  default = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
  description = "사용할 우분투 이미지"
}

variable "gcp_service_account_email" {
  default = "your-service-account@deep-thought-440807-g3.iam.gserviceaccount.com"
  description = "서비스 계정 이메일"
}
