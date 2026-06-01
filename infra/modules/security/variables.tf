variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "db_url" {
  type      = string
  sensitive = true
}

variable "jwt_secret" {
  type      = string
  sensitive = true
}

variable "better_auth_secret" {
  type      = string
  sensitive = true
}
