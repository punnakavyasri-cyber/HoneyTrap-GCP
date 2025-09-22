resource "google_compute_address" "honeypot_ip" {
  name   = "${local.prefix}-ip"
  region = var.region
}