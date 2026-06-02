variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "network_id" {
  type = string
}

variable "db_tier" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "authorized_ip" {
  type        = string
  description = "IP address authorized to connect to Cloud SQL (e.g. your dev machine)"
  default     = "0.0.0.0/0"
}
