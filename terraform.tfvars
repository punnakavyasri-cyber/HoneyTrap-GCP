project_id       = "Project_ID" # your existing project
region           = "us-east4"
zone             = "us-east4-a"
credentials_file = Credentials_Path&FileName # or "" if using ambient auth
name             = "honeytrap"
machine_type     = "e2-standard-4"
boot_disk_gb     = 100
ssh_username     = "ubuntu"
subnet_cidr      = Subnet_CIDR
admin_cidr       = Your_Public_IP/CIDR
service_account_email = # Include your Service Account Email

