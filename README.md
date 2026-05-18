# Terraform AWS Infrastructure (IaC)

Production-style Infrastructure as Code (IaC) projects built with Terraform on AWS.

This repository contains Terraform projects focused on:
- AWS infrastructure provisioning
- Remote backend configuration
- S3 state management
- VPC architecture
- Terraform best practices
- Infrastructure automation

---

# Technologies Used

- Terraform
- AWS
- Amazon S3
- DynamoDB
- VPC
- GitHub
- Infrastructure as Code (IaC)

---

# Repository Structure

```bash
Terraform_S3_VPC/
│
├── 06_05_remote_backend_s3bucket/
│   ├── terraform-manifests/
│   │   ├── c1-versions.tf
│   │   ├── c2-variables.tf
│   │   ├── c3-s3bucket.tf
│   │   ├── c4-outputs.tf
│   │   └── .terraform.lock.hcl
│
├── 06_06_vpc_with_remote_backend/
│   ├── terraform-manifests/
│   │   ├── c1-versions.tf
│   │   ├── c2-variables.tf
│   │   ├── c3-datasources-and-locals.tf
│   │   ├── c4-vpc.tf
│   │   ├── c5-outputs.tf
│   │   └── .terraform.lock.hcl
│
└── README.md
```

---

# Project Overview

## 06_05_remote_backend_s3bucket

This project provisions:
- S3 bucket for Terraform remote state
- Backend infrastructure for state management
- Versioning and state storage configuration

### Features
- Remote Terraform state management
- Infrastructure state centralization
- Production-style Terraform backend setup

---

## 06_06_vpc_with_remote_backend

This project provisions:
- AWS VPC
- Public and private subnets
- Networking components
- Remote backend state integration

### Features
- Modular Terraform structure
- Remote backend configuration
- AWS networking infrastructure
- Reusable Infrastructure as Code design

---

# Terraform Commands

## Initialize Terraform

```bash
terraform init
```

## Validate Configuration

```bash
terraform validate
```

## Format Terraform Files

```bash
terraform fmt
```

## Preview Infrastructure Changes

```bash
terraform plan
```

## Deploy Infrastructure

```bash
terraform apply
```

## Destroy Infrastructure

```bash
terraform destroy
```

---

# Terraform Backend

This repository demonstrates:
- Remote Terraform backend configuration
- S3 backend storage
- Terraform state management best practices

---

# Best Practices Implemented

- Remote backend state storage
- Terraform provider version locking
- Infrastructure modularization
- Git version control
- `.gitignore` for Terraform cache/state files
- Infrastructure as Code principles

---

# Files Ignored From Git

The following files/folders are excluded:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
terraform.tfvars
crash.log
```

---

# Prerequisites

Before running this project, ensure you have:

- AWS Account
- AWS CLI configured
- Terraform installed
- Git installed

---

# Configure AWS Credentials

```bash
aws configure
```

---

# Verify Terraform Installation

```bash
terraform version
```

---

# Future Enhancements

Planned infrastructure projects:
- EKS Cluster
- Application Load Balancer
- Route53
- Auto Scaling
- RDS
- Terraform Modules
- GitHub Actions CI/CD
- ArgoCD GitOps

---

# Learning Objectives

This repository was created to strengthen skills in:
- Terraform
- AWS Cloud Infrastructure
- Infrastructure as Code
- Remote Backend Configuration
- Networking
- DevOps Engineering

---

# Author

Tina Collins

GitHub:
https://github.com/tcollins520