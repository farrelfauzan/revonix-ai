output "lb_ip" {
  value = google_compute_global_address.lb.address
}

output "ssl_certificate_status" {
  value = google_compute_managed_ssl_certificate.main.self_link
}
