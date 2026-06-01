output "services" {
  value = {
    api       = google_cloud_run_v2_service.api.uri
    chat      = google_cloud_run_v2_service.chat.uri
    dashboard = google_cloud_run_v2_service.dashboard.uri
    landing   = google_cloud_run_v2_service.landing.uri
  }
}
