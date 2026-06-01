resource "google_sql_database_instance" "main" {
  name             = "renovix-db-${var.region}"
  database_version = "POSTGRES_16"
  region           = var.region
  project          = var.project_id

  settings {
    tier              = var.db_tier
    availability_type = "ZONAL"
    disk_size         = 10
    disk_type         = "PD_SSD"
    disk_autoresize   = true

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      start_time                     = "03:00"
      transaction_log_retention_days = 7

      backup_retention_settings {
        retained_backups = 14
      }
    }

    maintenance_window {
      day          = 7
      hour         = 3
      update_track = "stable"
    }

    database_flags {
      name  = "max_connections"
      value = "100"
    }

    insights_config {
      query_insights_enabled  = true
      record_application_tags = true
      record_client_address   = true
    }
  }

  deletion_protection = true
}

resource "google_sql_database" "main" {
  name     = "renovix_ai"
  instance = google_sql_database_instance.main.name
  project  = var.project_id
}

resource "google_sql_user" "app" {
  name     = "renovix_app"
  instance = google_sql_database_instance.main.name
  password = var.db_password
  project  = var.project_id
}
