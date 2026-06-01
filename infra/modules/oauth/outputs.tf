output "secret_ids" {
  description = "OAuth-related secret IDs to pass to Cloud Run"
  value = {
    GOOGLE_OAUTH_CLIENT_ID     = google_secret_manager_secret.google_oauth_client_id.secret_id
    GOOGLE_OAUTH_CLIENT_SECRET = google_secret_manager_secret.google_oauth_client_secret.secret_id
    MCP_GOOGLE_CLIENT_ID       = google_secret_manager_secret.mcp_google_client_id.secret_id
    MCP_GOOGLE_CLIENT_SECRET   = google_secret_manager_secret.mcp_google_client_secret.secret_id
    MCP_ENCRYPTION_KEY         = google_secret_manager_secret.mcp_encryption_key.secret_id
    GITHUB_OAUTH_CLIENT_ID     = google_secret_manager_secret.github_oauth_client_id.secret_id
    GITHUB_OAUTH_CLIENT_SECRET = google_secret_manager_secret.github_oauth_client_secret.secret_id
    MCP_SLACK_CLIENT_ID        = google_secret_manager_secret.slack_client_id.secret_id
    MCP_SLACK_CLIENT_SECRET    = google_secret_manager_secret.slack_client_secret.secret_id
  }
}
