# ─── OAuth Secrets ──────────────────────────────────────────────────────────────
# NOTE: Google IAP Brand/Clients require the project to belong to a GCP Organization.
# Since this project is standalone, create OAuth clients manually in Google Cloud Console
# (APIs & Services > Credentials) and populate these secrets after deploy.

# ─── Secret Manager: Store OAuth credentials ───────────────────────────────────
# SSO credentials (manually created in GCP Console > APIs & Services > Credentials)
resource "google_secret_manager_secret" "google_oauth_client_id" {
  secret_id = "google-oauth-client-id"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "google_oauth_client_id" {
  secret      = google_secret_manager_secret.google_oauth_client_id.id
  secret_data = "REPLACE_ME"

  lifecycle {
    ignore_changes = [secret_data]
  }
}

resource "google_secret_manager_secret" "google_oauth_client_secret" {
  secret_id = "google-oauth-client-secret"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "google_oauth_client_secret" {
  secret      = google_secret_manager_secret.google_oauth_client_secret.id
  secret_data = "REPLACE_ME"

  lifecycle {
    ignore_changes = [secret_data]
  }
}

# MCP Google integration credentials
resource "google_secret_manager_secret" "mcp_google_client_id" {
  secret_id = "mcp-google-client-id"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "mcp_google_client_id" {
  secret      = google_secret_manager_secret.mcp_google_client_id.id
  secret_data = "REPLACE_ME"

  lifecycle {
    ignore_changes = [secret_data]
  }
}

resource "google_secret_manager_secret" "mcp_google_client_secret" {
  secret_id = "mcp-google-client-secret"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "mcp_google_client_secret" {
  secret      = google_secret_manager_secret.mcp_google_client_secret.id
  secret_data = "REPLACE_ME"

  lifecycle {
    ignore_changes = [secret_data]
  }
}

# ─── MCP Token Encryption Key ──────────────────────────────────────────────────
# Used by the API to encrypt/decrypt OAuth tokens stored in UserMcpCredential.envEncrypted
resource "google_secret_manager_secret" "mcp_encryption_key" {
  secret_id = "mcp-encryption-key"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "mcp_encryption_key" {
  secret      = google_secret_manager_secret.mcp_encryption_key.id
  secret_data = var.mcp_encryption_key
}

# ─── GitHub OAuth (manual — created on github.com/settings/developers) ─────────
# These are created as empty secrets; set them manually after deploy.
resource "google_secret_manager_secret" "github_oauth_client_id" {
  secret_id = "github-oauth-client-id"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "github_oauth_client_secret" {
  secret_id = "github-oauth-client-secret"
  project   = var.project_id

  replication {
    auto {}
  }
}

# ─── MCP Provider Secrets (Slack, etc. — manual) ───────────────────────────────
resource "google_secret_manager_secret" "slack_client_id" {
  secret_id = "mcp-slack-client-id"
  project   = var.project_id

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "slack_client_secret" {
  secret_id = "mcp-slack-client-secret"
  project   = var.project_id

  replication {
    auto {}
  }
}

# ┌─────────────────────────────────────────────────────────────────────────────┐
# │  AFTER `terraform apply`, set these manual secrets:                         │
# │                                                                             │
# │  # GitHub OAuth (create at github.com/settings/developers)                  │
# │  # Callback URL: https://api.renovix.id/api/auth/better/callback/github     │
# │  gcloud secrets versions add github-oauth-client-id \                       │
# │    --data-file=- <<< "Iv1.xxxxxx"                                           │
# │                                                                             │
# │  gcloud secrets versions add github-oauth-client-secret \                   │
# │    --data-file=- <<< "xxxxx"                                                │
# │                                                                             │
# │  # Slack OAuth (create at api.slack.com/apps)                               │
# │  # Redirect URL: https://api.renovix.id/api/mcp/callback/slack              │
# │  gcloud secrets versions add mcp-slack-client-id \                          │
# │    --data-file=- <<< "xxxxx"                                                │
# │                                                                             │
# │  gcloud secrets versions add mcp-slack-client-secret \                      │
# │    --data-file=- <<< "xxxxx"                                                │
# └─────────────────────────────────────────────────────────────────────────────┘
