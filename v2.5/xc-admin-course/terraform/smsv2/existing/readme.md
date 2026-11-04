
# F5 Distributed Cloud (XC) SMSv2 CE Deployment into Existing AWS VPC

This Terraform project provisions one or more F5 Distributed Cloud Secure Mesh Site v2 (SMSv2) Customer Edge (CE) nodes into an **existing AWS VPC**.

---

## What Terraform Configures Automatically

Once you provide your existing `vpc_id`, `slo_subnet_id`, and `sli_subnet_id`, Terraform automatically provisions:

1. **SSH Key Pairs**:
   - Generates a dedicated 4096-bit RSA key pair per student (`tls_private_key.ce`).
   - Registers the public key with AWS EC2 (`aws_key_pair.ce`).
   - Saves the private key locally as `./<student>-smsv2-key.pem` with `0600` permissions (`local_sensitive_file.ssh_private_key`).

2. **Security Groups**:
   - **SLO Security Group** (`${student}-ce-slo-sg`): Ingress for SSH (22), ICMP (IPv4 ping), and Local UI access (65500); outbound all.
   - **SLI Security Group** (`${student}-ce-sli-sg`): Ingress allowed from the existing VPC CIDR; outbound all.

3. **Elastic IPs (On-Demand Allocation & Association)**:
   - Allocates an Elastic IP per student (`aws_eip.ce_slo`).
   - Associates the EIP directly to the SLO ENI (`aws_eip_association.ce_slo`).

4. **Network Interfaces (Dual-NIC Topology)**:
   - **SLO Interface** (`eth0` / `device_index = 0`): Bound to `var.slo_subnet_id` with the SLO security group and `source_dest_check = false`.
   - **SLI Interface** (`eth1` / `device_index = 1`): Bound to `var.sli_subnet_id` with the SLI security group and `source_dest_check = false`.

5. **F5 XC Control Plane**:
   - Creates the Secure Mesh Site v2 (`volterra_securemesh_site_v2.student`) in the `system` namespace.
   - Generates a site registration token (`volterra_token.student`).
   - Applies coordination delays (`time_sleep`) so the site and token stabilize before EC2 launch.

6. **EC2 Instance & Automatic Bootstrap**:
   - Launches an EC2 instance per student using the latest F5 XC CE AMI (or `var.ce_ami_id`).
   - Cloud-init populates `/etc/vpm/user_data` with the registration token, cluster name, and hostname.
   - Node registers with the F5 XC tenant controller automatically.

---

## Required Configuration

Update `students.auto.tfvars`:

```hcl
aws_region        = "us-east-1"
instance_type     = "m5.2xlarge"
volume_size       = 80
f5xc_api_p12_file = "./your-tenant.console.ves.volterra.io.api-creds.p12"
f5xc_api_url      = "https://your-tenant.console.ves.volterra.io/api"

# Existing AWS Network Configuration
vpc_id        = "vpc-0123456789abcdef0"
slo_subnet_id = "subnet-0123456789abcdef1"
sli_subnet_id = "subnet-0123456789abcdef2"

# Students / CE nodes to deploy
students = ["student101", "student102"]
```

Export necessary credentials before running:

```bash
export VES_P12_PASSWORD="your-p12-certificate-password"
export AWS_ACCESS_KEY_ID="your-aws-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-aws-secret-access-key"
export AWS_SESSION_TOKEN="optional-session-token"
```

---

## Usage

```bash
terraform init
terraform plan
terraform apply
```
