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
    - SSH admin access (22/tcp) from your admin_cidr
    - Honeypot broad ingress (public-facing ports)
    - Kibana dashboard access (64297/tcp) from your admin_cidr
- Compute Instance
- IP Address
- Outputs

📸 **Screenshot:**
![02-TFplanExpectedOutput](https://github.com/user-attachments/assets/87ea84a1-43f1-4fba-9479-96569e31eb3f)


### STEP 3.3 — Apply the configuration

Run the apply command to create all resources:

```bash
terraform apply
```

Terraform will show you the execution plan and then prompt for confirmation.
Type **yes** manually to proceed.

📸 **Screenshot:**
![03-TFapplyConfirmation](https://github.com/user-attachments/assets/0c215bc3-6c5b-4cf5-9464-f063697f0893)

Once complete, Terraform provisions:
- VPC
- Subnets
- Firewall Rules
- Compute Instance
- External IP Address
- Outputs

📸 **Screenshot:**
![04-TFapplyExpectedOutput](https://github.com/user-attachments/assets/fec3ee70-6194-4ed4-b516-2298f08767e0)

### STEP 3.4 — Post-apply checks

After the `terraform apply` is complete, go to the **GCP Console** and verify:

- **Compute Engine → VM instances**  
  - Confirm your VM is created.  
  - Check that it has the correct external IP, machine type, and tags `<prefix>-admin` / `<prefix>-public`.

- **VPC network → Firewall rules**  
  - Verify rules exist for SSH (`22/tcp`), Honeypot ingress, and Kibana (`64297/tcp`).  
  - Ensure each rule is restricted to your `admin_cidr` where required.

📸 **Screenshot:**
![05-GCPAfterVMCreation](https://github.com/user-attachments/assets/b8f4e491-bd9c-4d11-beee-f17b6c88236e)

## STEP 4 — Login to the VM

Terraform automatically created an SSH key pair during the VM provisioning.  
The private key was saved locally as **id_ed25519** (from Terraform output).  

Use the following command from Git Bash to connect to the VM:

```bash
ssh -i id_ed25519 ubuntu@<VM_EXTERNAL_IP>
```

- Replace <VM_EXTERNAL_IP> with the external IP of your VM (check the Terraform outputs or GCP Console).
- The username is ubuntu, as defined in terraform.tfvars (ssh_username = "ubuntu").

📸 **Screenshot:**
![06-sshLogin](https://github.com/user-attachments/assets/d569baf4-3d2e-44e9-92c3-391fa6b1ce27)

## STEP 5 — Verify startup script execution

The VM was provisioned with a startup script that automatically installed **Docker**, **Git**, and cloned the **T-Pot repo** into `/opt/tpotce`.

### Checks performed

1. **Confirm startup script logs**
   
   ```bash
   sudo journalctl -u google-startup-scripts.service
   ```
   **Expected Output:**
   ![07-StartupScript-ExpectedOutput](https://github.com/user-attachments/assets/e8ad4022-bb2b-4401-b377-387625986eb7)

2. **Check Docker version**

   ```bash
   docker --version
   ```
   **Expected Output:** <br>
   ![08-DockerVersion](https://github.com/user-attachments/assets/510f5420-bd42-4445-a4af-74f6ed26e677)

3. **Check Git version**

   ```bash
   git --version
   ```
   **Expected Output:** <br>
   ![09-GitVersion](https://github.com/user-attachments/assets/f85542c6-42ea-47ad-a7e9-5391d3908c73)

5. **Check Docker service**

   ```bash
   systemctl status docker
   ```
   **Expected Output:** <br>
   ![10-DockerStatus](https://github.com/user-attachments/assets/43b28861-fab9-47f5-bd79-24a12159b1c8)

6. **Verify T-Pot repo exists**

   ```bash
   ls -ld /opt/tpotce
   ```
   **Expected Output:** <br>
   ![11-tpotRepoClone](https://github.com/user-attachments/assets/21286420-6238-405b-986f-018c07493b4e)
