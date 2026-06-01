resource "google_storage_bucket" "main" {
  name     = "renovix-ai-storage-${var.project_id}"
  location = "ASIA"
  project  = var.project_id

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      num_newer_versions = 3
    }
  }

  lifecycle_rule {
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition {
      age = 90
    }
  }

  cors {
    origin          = ["https://*.${var.domain}"]
    method          = ["GET", "PUT"]
    response_header = ["Content-Type", "Content-Disposition"]
    max_age_seconds = 3600
  }
}

# Service account for storage access
resource "google_service_account" "storage_access" {
  account_id   = "renovix-storage-sa"
  display_name = "Renovix Storage Service Account"
  project      = var.project_id
}

resource "google_storage_bucket_iam_member" "storage_admin" {
  bucket = google_storage_bucket.main.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.storage_access.email}"
}

# HMAC key for S3-compatible API access
resource "google_storage_hmac_key" "api_key" {
  service_account_email = google_service_account.storage_access.email
  project               = var.project_id
}

# CDN backend bucket
resource "google_compute_backend_bucket" "cdn" {
  name        = "renovix-cdn-bucket"
  bucket_name = google_storage_bucket.main.name
  enable_cdn  = true
  project     = var.project_id

  cdn_policy {
    cache_mode                    = "CACHE_ALL_STATIC"
    default_ttl                   = 3600
    max_ttl                       = 86400
    signed_url_cache_max_age_sec  = 7200
  }
}
