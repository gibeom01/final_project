resource "google_project_iam_member" "service_account_user" {
  project = var.gcp_project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "user:${var.gcp_user_email}"

  condition {
    title       = "expires_after_${replace(var.gcp_expiration_date, "-", "_")}"
    description = "Expires at midnight of ${var.gcp_expiration_date}"
    expression  = "request.time < timestamp(\"${var.gcp_expiration_date}\")"
  }
}

resource "google_project_iam_member" "container_admin" {
  project = var.gcp_project_id
  role    = "roles/container.admin"
  member  = "user:${var.gcp_user_email}"

  condition {
    title       = "expires_after_${replace(var.gcp_expiration_date, "-", "_")}"
    description = "Expires at midnight of ${var.gcp_expiration_date}"
    expression  = "request.time < timestamp(\"${var.gcp_expiration_date}\")"
  }
}

resource "google_project_iam_member" "compute_admin" {
  project = var.gcp_project_id
  role    = "roles/compute.admin"
  member  = "user:${var.gcp_user_email}"

  condition {
    title       = "expires_after_${replace(var.gcp_expiration_date, "-", "_")}"
    description = "Expires at midnight of ${var.gcp_expiration_date}"
    expression  = "request.time < timestamp(\"${var.gcp_expiration_date}\")"
  }
}

resource "google_project_iam_member" "network_admin" {
  project = var.gcp_project_id
  role    = "roles/compute.networkAdmin"
  member  = "user:${var.gcp_user_email}"

  condition {
    title       = "expires_after_${replace(var.gcp_expiration_date, "-", "_")}"
    description = "Expires at midnight of ${var.gcp_expiration_date}"
    expression  = "request.time < timestamp(\"${var.gcp_expiration_date}\")"
  }
}

resource "google_service_account" "default" {
  account_id   = "default-service-account"
  display_name = "Default Service Account"
}

resource "google_project_iam_member" "compute_network_user" {
  project = var.gcp_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "cloud_run_admin" {
  project = var.gcp_project_id
  role    = "roles/run.admin"
  member  = "user:${var.gcp_user_email}"
}

resource "google_project_iam_member" "compute_network_admin" {
  project = var.gcp_project_id
  role    = "roles/compute.networkAdmin"
  member  = "user:${var.gcp_user_email}"
}

resource "google_project_iam_member" "compute_instance_admin" {
  project = var.gcp_project_id
  role    = "roles/compute.instanceAdmin"
  member  = "user:${var.gcp_user_email}"
}

resource "google_project_iam_member" "compute_load_balancer_admin" {
  project = var.gcp_project_id
  role    = "roles/compute.loadBalancerAdmin"
  member  = "user:${var.gcp_user_email}"
}

resource "google_project_iam_member" "compute_backend_service_admin" {
  project = var.gcp_project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "compute_health_check_admin" {
  project = var.gcp_project_id
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "monitoring_viewer" {
  project = var.gcp_project_id
  role    = "roles/monitoring.viewer"
  member  = "user:${var.gcp_user_email}"
}

resource "google_project_iam_member" "monitoring_admin" {
  project = var.gcp_project_id
  role    = "roles/monitoring.admin"
  member  = "user:${var.gcp_user_email}"
}

resource "google_project_iam_member" "iam_role_viewer" {
  project = var.gcp_project_id
  role    = "roles/iam.roleViewer"
  member  = "user:${var.gcp_user_email}"
}

resource "google_project_iam_member" "logging_viewer" {
  project = var.gcp_project_id
  role    = "roles/logging.viewer"
  member  = "user:${var.gcp_user_email}"
}

resource "google_project_iam_member" "logging_admin" {
  project = var.gcp_project_id
  role    = "roles/logging.admin"
  member  = "user:${var.gcp_user_email}"
}
