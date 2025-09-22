# locals {
#   # If you don’t pass service_account_email, use the default:
#   # <PROJECT_NUMBER>-compute@developer.gserviceaccount.com
#   sa_email = var.service_account_email
# }

resource "google_compute_instance" "honeypot" {
  name         = "${local.prefix}-vm"
  zone         = var.zone
  machine_type = var.machine_type
  tags         = ["${local.prefix}-admin", "${local.prefix}-public"]

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
      size  = var.boot_disk_gb
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      nat_ip = google_compute_address.honeypot_ip.address
    }
  }

  service_account {
    email  = var.service_account_email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata = {
    "block-project-ssh-keys" = "true"
    "ssh-keys"               = "${var.ssh_username}:${tls_private_key.ssh.public_key_openssh}"
  }

  metadata_startup_script = file("${path.module}/files/startup.sh")
}