# HoneyTrap-GCP 🐝🔐

## 1. Introduction  
HoneyTrap-GCP is an Infrastructure-as-Code project that provisions a honeypot lab on **Google Cloud Platform (GCP)** using **Terraform**. The environment aims to capture real-world attacker behaviour in a controlled cloud setting so you can practise SOC analysis, detection engineering, and incident investigation.  

This repository bootstraps networking, compute, and firewall resources, deploys a public-facing honeypot (T-Pot CE) and a restricted admin VM, and hosts a Dockerized **Kibana/Elastic** dashboard for visualizing collected telemetry. The deployment is partially complete: the dashboards are deployed but the Threat Analysis phase (explore Elastic, enumerate attackers, map strategies) is still pending and documented as the next milestone.


## 2. Purpose of the project
- Deploy a repeatable honeypot environment in GCP using Terraform.  
- Provide an isolated, observable environment to collect attacker telemetry.  
- Surface attacker activity into Elastic/Kibana for visualization and analysis.  
- Practice SOC workflows: detection → triage → investigation → reporting.  
- Build a foundation for IDS/Suricata, SIEM, and enrichment integrations.  
- Produce actionable findings (IOCs, attacker TTPs, timeline of compromise).


## 3. Architecture Diagram





## 4. Technologies used
- **Google Cloud Platform (GCP)** — compute & networking  
- **Terraform** — IaC for VPC, firewall, VM provisioning  
- **T-Pot CE** (telekom-security) — multi-honeypot framework (credit below)  
- **Docker** — run Kibana/Elastic containers (local or admin VM)  
- **Kibana / Elastic** — log visualization & analysis 


## 5. Pre-requisites
- A free **GCP account** with billing enabled  
- **Terraform CLI** installed on your machine  
- **gcloud CLI** installed and configured with GCP account  

---

## 6. Project workflow
**High level (start → dashboard):**
1. Create a **Service Account** in GCP with required roles (Compute Admin, Storage Admin, etc.) and download the key JSON.  
2. Place key JSON on your machine and reference it in `provider` credentials (or use `gcloud auth application-default login`).  
3. Fill `terraform.tfvars` (use `terraform.tfvars.example` as template).  
4. `terraform init` → `terraform plan` → `terraform apply` to create VPC, firewall, and VMs.  
5. Provision Admin VM (SSH restricted) and Honeypot VM (public). Honeypot deploys T-Pot CE components.  
6. Run Kibana in Docker on admin VM and connect it to collected telemetry (Elastic endpoints).  
7. Open Kibana, validate dashboards, and begin Threat Analysis.

**Detailed step-by-step workflow is in:** `WORKFLOW.md` — (detailed commands, IAM roles, provisioning notes, and troubleshooting).

**Notes about your current status:**  
- Dashboards (Elastic/Kibana) are deployed — ✅  
- Next: *explore the dashboard to identify who attacked the honeypot, what they attempted, and map their strategy (TTPs/IOC extraction)* — 🔎

**Planned analysis activities to keep in mind while exploring Elastic:**
- Inspect high-volume source IPs and timelines.  
- Query for common attack vectors (SSH brute force, HTTP exploit attempts, scanning, CVE probes).  
- Extract indicators: IPs, domains, user-agents, payloads, file hashes.  
- Map observed activity to **MITRE ATT&CK** tactics & techniques.  
- Reconstruct attacker session timelines and pivot between logs (suricata, syslog, docker logs, connection records).  
- Prepare a short report per attacker group: summary, IOCs, suggested detections, and containment steps.

---

## 7. Future Expansions
- Integrate **Elasticsearch** as a persistent backend (if not already done) and optimize index lifecycle policies.  
- Add **Suricata / Zeek** to the honeypot pipeline for richer network indicators and PCAP capture.  
- Enrich logs with **GeoIP, ASN, WHOIS** for faster triage.  
- Create automated **detection rules & alerts** in Kibana/Alerting (email/Slack).  
- Add **SIEM connectors** (Splunk/Elastic SIEM) and a scheduled IOC extractor.  
- Implement CI/CD: GitHub Actions for linting Terraform, and Terraform Cloud for remote runs and state.  
- Develop a reporting notebook (Jupyter) to summarize attacker TTPs and produce artifacts for sharing.

---

## Credits & Acknowledgements
This project uses and builds upon the open **T-Pot CE** honeypot framework by Telekom Security:  
- T-Pot CE: https://github.com/telekom-security/tpotce — many honeypot components and deployment patterns are derived from this project. Please review their project and license for reuse details.

---

## License
This repository is licensed under the **MIT License** — see `LICENSE` for details.

---

## Quick security checklist (do this before committing)
- Remove or replace any real values in `terraform.tfvars` with placeholders (commit `terraform.tfvars.example` instead).  
- Add the following to `.gitignore`:
