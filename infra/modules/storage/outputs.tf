output "bucket_name" {
  value = google_storage_bucket.main.name
}

output "bucket_backend" {
  value = google_compute_backend_bucket.cdn.self_link
}

output "hmac_access_id" {
  value     = google_storage_hmac_key.api_key.access_id
  sensitive = true
}

output "hmac_secret" {
  value     = google_storage_hmac_key.api_key.secret
  sensitive = true
}
