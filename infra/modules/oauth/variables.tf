variable "project_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "oauth_support_email" {
  description = "Support email shown on OAuth consent screen"
  type        = string
}

variable "mcp_encryption_key" {
  description = "AES-256 key for encrypting MCP OAuth tokens at rest (base64-encoded 32 bytes)"
  type        = string
  sensitive   = true
}
