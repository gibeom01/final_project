resource "google_project_iam_binding" "service_account_user" {
  project = "deep-thought-440807-g3"
  role    = "roles/iam.serviceAccountUser"

  members = [
    "user:rlqja7638@gmail.com"
  ]

  condition {
    title       = "expires_after_2025_01_01"
    description = "Expiring at midnight of 2025-01-01"
    expression  = "request.time < timestamp(\"2025-01-01T00:00:00Z\")"
  }
}

resource "google_project_iam_binding" "container_admin" {
  project = "deep-thought-440807-g3"
  role    = "roles/container.admin"

  members = [
    "user:rlqja7638@gmail.com"
  ]

  condition {
    title       = "expires_after_2025_01_01"
    description = "Expiring at midnight of 2025-01-01"
    expression  = "request.time < timestamp(\"2025-01-01T00:00:00Z\")"
  }
}

resource "google_project_iam_binding" "compute_admin" {
  project = "deep-thought-440807-g3"
  role    = "roles/compute.admin"

  members = [
    "user:rlqja7638@gmail.com"
  ]

  condition {
    title       = "expires_after_2025_01_01"
    description = "Expiring at midnight of 2025-01-01"
    expression  = "request.time < timestamp(\"2025-01-01T00:00:00Z\")"
  }
}

resource "google_project_iam_binding" "compute_network_admin" {
  project = "deep-thought-440807-g3"
  role    = "roles/compute.networkAdmin"

  members = [
    "user:rlqja7638@gmail.com"
  ]

  condition {
    title       = "expires_after_2025_01_01"
    description = "Expiring at midnight of 2025-01-01"
    expression  = "request.time < timestamp(\"2025-01-01T00:00:00Z\")"
  }
}
