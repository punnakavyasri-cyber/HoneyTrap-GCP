# SSH only from your admin IP to instances tagged "<prefix>-admin"
resource "google_compute_firewall" "allow_ssh_admin" {
  name          = "${local.prefix}-allow-ssh-admin"
  network       = google_compute_network.vpc.name
  target_tags   = ["${local.prefix}-admin"]
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = [var.admin_cidr]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  description = "SSH only from admin CIDR"
}

# Honeypot public ingress (broad by design) to "<prefix>-public"
resource "google_compute_firewall" "allow_honeypot_ingress" {
  name          = "${local.prefix}-allow-honeypot"
  network       = google_compute_network.vpc.name
  target_tags   = ["${local.prefix}-public"]
  direction     = "INGRESS"
  priority      = 1001
  source_ranges = ["0.0.0.0/0"]

  allow { protocol = "all" }

  description = "Public ingress for honeypot services"
}

# Egress all
resource "google_compute_firewall" "egress_all" {
  name               = "${local.prefix}-egress-all"
  network            = google_compute_network.vpc.name
  direction          = "EGRESS"
  priority           = 1000
  destination_ranges = ["0.0.0.0/0"]
  allow { protocol = "all" }
  description = "Allow all egress"
}
