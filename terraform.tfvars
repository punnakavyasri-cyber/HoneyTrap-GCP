project_id       = "honeypot-472820" # your existing project
region           = "us-east4"
zone             = "us-east4-a"
credentials_file = "honeypot-472820-f708d28dc8ce.json" # or "" if using ambient auth
name             = "honeytrap"
machine_type     = "e2-standard-4"
boot_disk_gb     = 100
ssh_username     = "ubuntu"
subnet_cidr      = "10.20.0.0/24"
admin_cidr       = "98.29.213.209/32"
service_account_email = "honeypot@honeypot-472820.iam.gserviceaccount.com"

