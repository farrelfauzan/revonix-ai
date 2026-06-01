output "cloud_run_urls" {
  description = "Cloud Run service URLs"
  value       = module.cloud_run.services
}

output "database_connection_name" {
  description = "Cloud SQL connection name for Cloud SQL Proxy"
  value       = module.database.connection_name
}

output "bucket_name" {
  description = "GCS bucket name"
  value       = module.storage.bucket_name
}

output "artifact_registry" {
  description = "Docker image registry URL"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/renovix"
}
