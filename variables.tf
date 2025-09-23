variable "project_id" {
  description = "Existing GCP project ID (e.g., honeypot-472820)"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

variable "credentials_file" {
  description = "Path to service account JSON (leave empty to use ambient auth)"
  type        = string
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "honeytrap"
}

variable "subnet_cidr" {
  description = "CIDR for the subnet"
  type        = string
  default     = "10.20.0.0/24"
}

variable "admin_cidr" {
  description = "Your public IP/CIDR for SSH (e.g., 1.2.3.4/32)"
  type        = string
}

variable "machine_type" {
  description = "Compute Engine machine type"
  type        = string
}

variable "boot_disk_gb" {
  description = "Boot disk size (GB)"
  type        = number
}

variable "ssh_username" {
  description = "Linux username for SSH key injection"
  type        = string
}

variable "service_account_email" {
  description = "Existing service account email to attach to the VM; leave empty to use the project’s default Compute Engine service account"
  type        = string
}