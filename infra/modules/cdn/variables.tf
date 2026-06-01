variable "project_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "cloud_run" {
  type = map(string)
}

variable "storage_backend" {
  type = string
}
