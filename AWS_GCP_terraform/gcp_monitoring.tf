resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Notification Channel"
  type         = "email"
  labels = {
    email_address = "rlqja7638@gmail.com"
  }
}

resource "google_project_service" "required_services" {
  for_each = toset([
    "container.googleapis.com",    
    "monitoring.googleapis.com"    
  ])
  service = each.value
  project = "deep-thought-440807-g3"
}

resource "google_monitoring_alert_policy" "gke_node_cpu_alert" {
  display_name = "GKE Node CPU Utilization > 50%"

  documentation {
    content = "The $${metric.display_name} of the GKE Node $${resource.type} $${resource.label.instance_id} has exceeded 50% for over 1 minute."
  }

  combiner = "OR"

  conditions {
    display_name = "GKE Node CPU Condition"
    condition_threshold {
      comparison    = "COMPARISON_GT"
      duration      = "60s"
      filter        = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\""
      threshold_value = 0.5  

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  alert_strategy {
    notification_channel_strategy {
      renotify_interval       = "1800s"
      notification_channel_names = [google_monitoring_notification_channel.email.name]
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  user_labels = {
    severity = "critical"
  }
}

resource "google_project_service" "monitoring_service" {
  project = "deep-thought-440807-g3"
  service = "monitoring.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "container_service" {
  project = "deep-thought-440807-g3"
  service = "container.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "cloudapis_service" {
  project = "deep-thought-440807-g3"
  service = "cloudapis.googleapis.com"
  disable_dependent_services = false
}
