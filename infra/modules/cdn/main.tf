# ─── SSL Certificate ───
resource "google_compute_managed_ssl_certificate" "main" {
  name    = "renovix-ssl-cert"
  project = var.project_id

  managed {
    domains = [
      var.domain,
      "www.${var.domain}",
      "dashboard.${var.domain}",
      "chat.${var.domain}",
      "api.${var.domain}",
      "cdn.${var.domain}",
    ]
  }
}

# ─── Network Endpoint Groups (Serverless NEGs for Cloud Run) ───
resource "google_compute_region_network_endpoint_group" "api" {
  name                  = "renovix-neg-api"
  network_endpoint_type = "SERVERLESS"
  region                = "asia-southeast2"
  project               = var.project_id

  cloud_run {
    service = "renovix-api"
  }
}

resource "google_compute_region_network_endpoint_group" "chat" {
  name                  = "renovix-neg-chat"
  network_endpoint_type = "SERVERLESS"
  region                = "asia-southeast2"
  project               = var.project_id

  cloud_run {
    service = "renovix-chat"
  }
}

resource "google_compute_region_network_endpoint_group" "dashboard" {
  name                  = "renovix-neg-dashboard"
  network_endpoint_type = "SERVERLESS"
  region                = "asia-southeast2"
  project               = var.project_id

  cloud_run {
    service = "renovix-dashboard"
  }
}

resource "google_compute_region_network_endpoint_group" "landing" {
  name                  = "renovix-neg-landing"
  network_endpoint_type = "SERVERLESS"
  region                = "asia-southeast2"
  project               = var.project_id

  cloud_run {
    service = "renovix-landing"
  }
}

# ─── Backend Services ───
resource "google_compute_backend_service" "api" {
  name    = "renovix-backend-api"
  project = var.project_id

  protocol = "HTTPS"

  backend {
    group = google_compute_region_network_endpoint_group.api.id
  }
}

resource "google_compute_backend_service" "chat" {
  name    = "renovix-backend-chat"
  project = var.project_id

  protocol = "HTTPS"

  backend {
    group = google_compute_region_network_endpoint_group.chat.id
  }

  cdn_policy {
    cache_mode                      = "CACHE_ALL_STATIC"
    default_ttl                     = 3600
    max_ttl                         = 86400
    signed_url_cache_max_age_sec    = 3600
  }

  enable_cdn = true
}

resource "google_compute_backend_service" "dashboard" {
  name    = "renovix-backend-dashboard"
  project = var.project_id

  protocol = "HTTPS"

  backend {
    group = google_compute_region_network_endpoint_group.dashboard.id
  }

  cdn_policy {
    cache_mode                      = "CACHE_ALL_STATIC"
    default_ttl                     = 3600
    max_ttl                         = 86400
    signed_url_cache_max_age_sec    = 3600
  }

  enable_cdn = true
}

resource "google_compute_backend_service" "landing" {
  name    = "renovix-backend-landing"
  project = var.project_id

  protocol = "HTTPS"

  backend {
    group = google_compute_region_network_endpoint_group.landing.id
  }

  cdn_policy {
    cache_mode                      = "CACHE_ALL_STATIC"
    default_ttl                     = 3600
    max_ttl                         = 86400
    signed_url_cache_max_age_sec    = 3600
  }

  enable_cdn = true
}

# ─── URL Map (routing) ───
resource "google_compute_url_map" "main" {
  name            = "renovix-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.landing.id

  host_rule {
    hosts        = [var.domain, "www.${var.domain}"]
    path_matcher = "landing"
  }

  host_rule {
    hosts        = ["api.${var.domain}"]
    path_matcher = "api"
  }

  host_rule {
    hosts        = ["chat.${var.domain}"]
    path_matcher = "chat"
  }

  host_rule {
    hosts        = ["dashboard.${var.domain}"]
    path_matcher = "dashboard"
  }

  host_rule {
    hosts        = ["cdn.${var.domain}"]
    path_matcher = "cdn"
  }

  path_matcher {
    name            = "landing"
    default_service = google_compute_backend_service.landing.id
  }

  path_matcher {
    name            = "api"
    default_service = google_compute_backend_service.api.id
  }

  path_matcher {
    name            = "chat"
    default_service = google_compute_backend_service.chat.id
  }

  path_matcher {
    name            = "dashboard"
    default_service = google_compute_backend_service.dashboard.id
  }

  path_matcher {
    name            = "cdn"
    default_service = var.storage_backend
  }
}

# ─── HTTPS Proxy ───
resource "google_compute_target_https_proxy" "main" {
  name    = "renovix-https-proxy"
  project = var.project_id

  url_map          = google_compute_url_map.main.id
  ssl_certificates = [google_compute_managed_ssl_certificate.main.id]
}

# ─── Global Forwarding Rule (entry point) ───
resource "google_compute_global_forwarding_rule" "https" {
  name    = "renovix-https-rule"
  project = var.project_id

  target     = google_compute_target_https_proxy.main.id
  port_range = "443"
  ip_address = google_compute_global_address.lb.address
}

# ─── HTTP → HTTPS Redirect ───
resource "google_compute_url_map" "http_redirect" {
  name    = "renovix-http-redirect"
  project = var.project_id

  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }
}

resource "google_compute_target_http_proxy" "redirect" {
  name    = "renovix-http-proxy"
  project = var.project_id
  url_map = google_compute_url_map.http_redirect.id
}

resource "google_compute_global_forwarding_rule" "http" {
  name    = "renovix-http-rule"
  project = var.project_id

  target     = google_compute_target_http_proxy.redirect.id
  port_range = "80"
  ip_address = google_compute_global_address.lb.address
}

# ─── Static IP ───
resource "google_compute_global_address" "lb" {
  name    = "renovix-lb-ip"
  project = var.project_id
}
