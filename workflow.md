## STEP 1 — Create Service Account + Key in GCP
1. Go to **GCP Console → IAM & Admin → Service Accounts → Create Service Account**.  

2. Assign **Owner** role to this service account.  
   - ⚠️ Note: Owner includes full project-level permissions (broad access). For production, it’s better to restrict to minimum roles (Compute Admin, Network Admin, Service Account User, etc.), but for this project you used **Owner** for simplicity.  
3. Create a **JSON key** for the Service Account and **download** it.  
4. Save the JSON file securely on your local system (e.g., `/path/to/honeypot-sa.json`).  
5. **Do not commit** this key file into GitHub — keep it private and add `*.json` to `.gitignore`.  

📸 **Screenshot:**
![00-ServiceAccountCreation](https://github.com/user-attachments/assets/cce7a2cf-8755-462b-b8a2-3fff06693bfe)

## STEP 2 — Prepare `terraform.tfvars`
After creating the Service Account, the next step was to define all required project-specific values in `terraform.tfvars`.

Here is the structure we used:

```hcl
project_id           = "Project_ID"               # your existing GCP project ID
region               = "us-east4"                 # region where VM is deployed
zone                 = "us-east4-a"               # specific zone inside the region
credentials_file     = "Credentials_Path&FileName" # path to your SA JSON file, or "filename" if using ambient auth
name                 = "honeytrap"                # project/VM prefix (used in names & tags)
machine_type         = "e2-standard-4"            # VM size for honeypot workload
boot_disk_gb         = 100                        # boot disk size in GB
ssh_username         = "ubuntu"                   # default username for VM login
subnet_cidr          = "Subnet_CIDR"              # CIDR block for the subnet
admin_cidr           = "Your_Public_IP/CIDR"      # restricts SSH & Kibana access to your IP
service_account_email = "YOUR_SA_EMAIL"           # service account email created in Step 1
```

## STEP 3 — Initialize and Deploy with Terraform

With `terraform.tfvars` filled (Step 2), deploy the infrastructure.

### 3.1 Initialize & validate
```bash
terraform init
```
`init` downloads the Google provider and sets up the working directory.

📸 **Screenshot:**
![01-TFinit](https://github.com/user-attachments/assets/474aee9a-c832-4ce5-be46-193446f38540)

### 3.2 Preview the plan
When running:

```bash
terraform plan
```

Terraform shows a plan to create the following resources:
- VPC
- Subnets
- Firewall Rules
- Compute Instance
- IP Address
    - SSH admin access (22/tcp) from your admin_cidr
    - Honeypot broad ingress (public-facing ports)
    - Kibana dashboard access (64297/tcp) from your admin_cidr
- Outputs

📸 **Screenshot:**
![02-TFplanExpectedOutput](https://github.com/user-attachments/assets/87ea84a1-43f1-4fba-9479-96569e31eb3f)

