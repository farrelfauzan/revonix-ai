output "connection_name" {
  value = google_sql_database_instance.main.connection_name
}

output "connection_url" {
  value     = "postgresql://renovix_app:${var.db_password}@/renovix_ai?host=/cloudsql/${google_sql_database_instance.main.connection_name}"
  sensitive = true
}
