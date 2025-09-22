output "honeypot_external_ip" {
  value       = google_compute_address.honeypot_ip.address
  description = "Public IP of the honeypot VM"
}

output "ssh_example" {
  value       = "ssh ${var.ssh_username}@${google_compute_address.honeypot_ip.address}"
  description = "SSH command example"
}

output "vpc_name" {
  value       = google_compute_network.vpc.name
  description = "VPC name"
}

output "subnet_name" {
  value       = google_compute_subnetwork.subnet.name
  description = "Subnet name"
}

# Optional: expose key material (private is sensitive)
output "ssh_private_key_pem" {
  description = "Private key to SSH into the VM"
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}