# Generate a new SSH keypair
resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

# Save the private key to a local file with restrictive permissions
resource "local_file" "private_key" {
  content              = tls_private_key.ssh.private_key_pem
  filename             = "${path.module}/id_ed25519"
  file_permission      = "0600"
  directory_permission = "0700"
}