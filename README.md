# Ashish Hake — Cloud & DevOps Portfolio Site

> A fully automated, production-grade static portfolio deployed on AWS — built to demonstrate real-world Cloud & DevOps engineering skills.

[![Deploy to AWS](https://img.shields.io/badge/Deploy-AWS-orange?logo=amazonaws)](https://github.com/ashishhake/portfolio-site)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-blue?logo=githubactions)](https://github.com/ashishhake/portfolio-site/actions)
[![IaC](https://img.shields.io/badge/IaC-Terraform-purple?logo=terraform)](https://www.terraform.io/)

---

## What This Project Demonstrates

This isn't just a personal website — it's a complete cloud infrastructure project. Every component is deliberately chosen to reflect production-quality DevOps practices:

- **Infrastructure as Code** with Terraform (S3, CloudFront, IAM, OAC)
- **Automated CI/CD pipeline** via GitHub Actions with validation, build, test, and deploy stages
- **Secure, keyless AWS authentication** using OIDC + IAM role federation (no static credentials)
- **Global CDN delivery** via CloudFront with HTTPS enforcement and cache invalidation
- **Code quality gates** — HTML validation and CSS linting run on every push before deployment

---

## Architecture Overview

```
Git Push (dev branch)
        │
        ▼
┌───────────────────┐
│  GitHub Actions   │  ← Validates HTML, lints CSS, scans for secrets
│  CI/CD Pipeline   │
└────────┬──────────┘
         │ OIDC (no static keys)
         ▼
┌───────────────────┐       ┌─────────────────────┐
│     AWS IAM       │──────▶│      Amazon S3       │  ← Static assets (private)
│  (Role + OIDC)    │       │  (versioned bucket)  │
└───────────────────┘       └──────────┬──────────┘
                                        │ OAC (signed requests)
                                        ▼
                            ┌─────────────────────┐
                            │   AWS CloudFront     │  ← HTTPS, global CDN, cache invalidation
                            │   (CDN + HTTPS)      │
                            └─────────────────────┘
                                        │
                                        ▼
                                   End Users 🌍
```

---

## Tech Stack

| Category | Technology |
|---|---|
| Cloud Provider | AWS (S3, CloudFront, IAM) |
| Infrastructure as Code | Terraform |
| CI/CD | GitHub Actions |
| Authentication | AWS OIDC + IAM Role (keyless) |
| Frontend | HTML5, CSS3, JavaScript, Tailwind CSS |
| Code Quality | html-validate, Stylelint |
| Package Management | npm |

---

## CI/CD Pipeline

The pipeline runs automatically on every push to the `dev` branch and consists of four sequential jobs:

```
validate → build → test → deploy
```

**`validate`** — Installs dependencies, validates HTML, lints CSS, and scans for accidentally committed AWS credentials.

**`build`** — Copies the `site/` directory into a `dist/` artifact and uploads it for downstream jobs.

**`test`** — Downloads the build artifact and verifies required files (`index.html`, `404.html`) exist and no file exceeds the size threshold.

**`deploy`** — Authenticates to AWS via OIDC (no stored keys), syncs the artifact to S3, and triggers a CloudFront cache invalidation so changes go live immediately.

---

## Infrastructure (Terraform)

All AWS resources are defined as code in the `terraform/` directory. A single `terraform apply` provisions the entire stack from scratch.

**Resources provisioned:**

- **S3 Bucket** — private bucket with versioning enabled; all public access blocked
- **CloudFront Distribution** — global CDN with HTTPS redirect, `PriceClass_200` (North America, Europe, Asia)
- **Origin Access Control (OAC)** — CloudFront-to-S3 signed requests via SigV4; no public S3 URLs exposed
- **S3 Bucket Policy** — restricts `s3:GetObject` exclusively to the CloudFront distribution ARN

### Quick Start

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your region and bucket name

terraform init
terraform plan
terraform apply
```

**Outputs after apply:**

```
s3_bucket_name             = "your-bucket-name"
cloudfront_distribution_id = "ABCDEF123456"
cloudfront_domain_name     = "d1234abcd.cloudfront.net"
```

---

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── deploy.yml        # GitHub Actions CI/CD pipeline
├── site/
│   ├── index.html            # Main portfolio page
│   ├── 404.html              # Custom error page
│   ├── css/
│   │   └── styles.css        # Custom styles
│   ├── js/
│   │   └── main.js           # Typewriter animation & interactions
│   └── assets/               # Images, resume PDF
├── terraform/
│   ├── main.tf               # S3, CloudFront, IAM resources
│   ├── variables.tf          # Input variable definitions
│   ├── outputs.tf            # Stack output values
│   ├── terraform.tfvars      # Your environment config (gitignored)
│   └── terraform.tfvars.example
├── scripts/
│   └── bootstrap-iam.sh      # One-time OIDC + IAM role setup
├── package.json              # npm scripts for validation
└── .stylelintrc.json         # CSS linting rules
```

---

## Security Highlights

- **No static AWS credentials** — GitHub Actions authenticates via OIDC, assuming an IAM role scoped to this repository only
- **Private S3 bucket** — all public access is blocked at the bucket level; content is served exclusively through CloudFront
- **OAC over legacy OAI** — uses the modern Origin Access Control with SigV4 signing
- **Secret scanning** — the pipeline regex-scans the codebase for AWS access key patterns before every deployment
- **HTTPS enforced** — CloudFront redirects all HTTP traffic to HTTPS

---

## Local Development

```bash
# Install dev dependencies
npm install

# Validate HTML
npm run test

# Lint CSS
npm run lint:css

# Serve the site locally
npm run serve
```

---

## One-Time AWS Setup

Before the pipeline can deploy, run the bootstrap script once to create the OIDC provider and IAM role in your AWS account:

```bash
# Edit the variables at the top of the script, then:
bash scripts/bootstrap-iam.sh
```

Add the output role ARN as a GitHub Secret named `AWS_ROLE_ARN`. Set `AWS_REGION`, `S3_BUCKET_NAME`, and `CLOUDFRONT_DISTRIBUTION_ID` as GitHub repository variables.

---


**Ashish Hake** — Cloud & DevOps Engineer

[ashishhake007@gmail.com](mailto:ashishhake007@gmail.com) · [github.com/ashishhake](https://github.com/ashishhake) · [linkedin.com/in/ashishhake](https://www.linkedin.com/in/ashishhake/)