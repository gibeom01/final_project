resource "google_project_iam_binding" "service_account_user" {
  project = "deep-thought-440807-g3"
  role    = "roles/iam.serviceAccountUser"

  members = [
    "user:rlqja7638@gmail.com"
  ]

  condition {
    title       = "expires_after_2024_11_30"
    description = "Expiring at midnight of 2024-11-30"
    expression  = "request.time < timestamp(\"2024-12-01T00:00:00Z\")"
  }
}

resource "google_project_iam_binding" "container_admin" {
  project = "deep-thought-440807-g3"
  role    = "roles/container.admin"

  members = [
    "user:rlqja7638@gmail.com"
  ]

  condition {
    title       = "expires_after_2024_11_30"
    description = "Expiring at midnight of 2024-11-30"
    expression  = "request.time < timestamp(\"2024-12-01T00:00:00Z\")"
  }
}

resource "google_project_iam_binding" "compute_admin" {
  project = "deep-thought-440807-g3"
  role    = "roles/compute.admin"

  members = [
    "user:rlqja7638@gmail.com"
  ]

  condition {
    title       = "expires_after_2024_11_30"
    description = "Expiring at midnight of 2024-11-30"
    expression  = "request.time < timestamp(\"2024-12-01T00:00:00Z\")"
  }
}
