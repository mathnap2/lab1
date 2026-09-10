# Lab1 — EC2 instance + DNS with Terraform

**Repo:** https://github.com/mathnap2/lab1
**Student:** mathias.napoles@iteso.mx — ID 745671

Deploys a single EC2 instance in the **default VPC** of an AWS Academy
Learner Lab account, plus DNS managed as code:

- Amazon Linux 2023 (latest AMI, auto-looked-up)
- `t2.micro`, 8 GiB encrypted gp3 root volume, IMDSv2 required
- A freshly generated 4096-bit RSA key pair; the private key is saved to
  `lab1-key.pem` in this folder
- A security group allowing **SSH (22)** from your current public IP only,
  **HTTP (80)** from anywhere, and all outbound traffic
- An **Elastic IP** so the address is stable
- An **Amazon Route 53** public hosted zone with `A` records
  (`www.<zone>` and the apex) pointing at the Elastic IP
- nginx serving a small page that prints the instance metadata and its
  DNS names

## DNS notes

AWS Academy Learner Lab does **not** allow registering a real domain, so the
Route 53 hosted zone created here is not delegated from a registrar. It still
demonstrates managing DNS with Terraform (hosted zone + records + delegation
set in `route53_name_servers`).

For a hostname that resolves from anywhere **right now** (screenshots /
grading), the `web_url` output uses [sslip.io](https://sslip.io), a free
wildcard DNS service:

```
http://www.<dashed-elastic-ip>.sslip.io   ->   the instance
```

## Prerequisites

- Terraform >= 1.5 on your PATH (`terraform version`)
- AWS CLI configured with the `academy` profile and a **valid, non-expired**
  Learner Lab session (`aws sts get-caller-identity --profile academy`)

## Usage

```powershell
cd lab1
terraform init
terraform plan
terraform apply
```

Open the site:

```powershell
terraform output -raw web_url
```

SSH in:

```powershell
terraform output -raw ssh_command
```

Tear everything down:

```powershell
terraform destroy
```

## Variables

| Variable            | Default                   | Notes                                                        |
| ------------------- | ------------------------- | ----------------------------------------------------------- |
| `aws_region`        | `us-east-1`               | Learner Lab region                                          |
| `aws_profile`       | `academy`                 | AWS CLI named profile                                       |
| `project_name`      | `lab1`                    | Name/tag prefix                                             |
| `instance_type`     | `t2.micro`                |                                                            |
| `root_volume_size`  | `8`                       | GiB                                                        |
| `ssh_ingress_cidr`  | `""`                      | Empty = auto-detect your IP; or `"x.x.x.x/32"`, `0.0.0.0/0` |
| `dns_zone_name`     | `dse-lab1-745671.com`     | Route 53 hosted zone name                                   |
| `dns_record_name`   | `www`                     | Hostname (relative to the zone) for the A record            |
| `student_id`        | `745671`                  | Applied as a resource tag                                   |
| `student_email`     | `mathias.napoles@iteso.mx`| Applied as a resource tag                                   |

## Key outputs

| Output                 | Meaning                                            |
| ---------------------- | ------------------------------------------------- |
| `public_ip`            | Elastic IP of the instance                        |
| `web_url`              | Resolvable HTTP URL (sslip.io)                    |
| `route53_fqdn`         | FQDN of the A record in Route 53                  |
| `route53_name_servers` | Delegation set for the hosted zone               |
| `ssh_command`          | Ready-to-use SSH command                          |

## Notes for AWS Academy Learner Lab

- Session credentials expire (~3–4 h). If `apply`/`destroy` fails with an
  auth error, start the lab again and refresh the `academy` profile
  credentials, then re-run.
- This config creates **no IAM roles/instance profiles** (not permitted in
  Learner Lab).
- State is local (`terraform.tfstate` in this folder). Don't commit it.
