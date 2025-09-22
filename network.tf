resource "google_compute_network" "vpc" {
  name                    = "${local.prefix}-vpc"
  auto_create_subnetworks = false
  description             = "Isolated VPC for HoneyTrap"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${local.prefix}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}
