# Terraform AWS Infrastructure (IaC)

Production-style Infrastructure as Code (IaC) projects built with Terraform on AWS.

This repository contains Terraform projects focused on:
- AWS infrastructure provisioning
- Remote backend configuration
- VPC networking
- Amazon EKS infrastructure
- Terraform state management
- Infrastructure automation
- DevOps and Cloud Engineering best practices

---

# Technologies Used

- Terraform
- AWS
- Amazon EKS
- Amazon VPC
- Amazon S3
- DynamoDB
- IAM
- GitHub
- Infrastructure as Code (IaC)

---

# Repository Structure

```bash
Terraform_S3_VPC/
│
├── 06_05_remote_backend_s3bucket/
│   ├── terraform-manifests/
│
├── 06_06_vpc_with_remote_backend/
│   ├── terraform-manifests/
│
├── EKS/
│   ├── terraform-manifests/
│
└── README.md
```

---

# Project Overview

## 06_05_remote_backend_s3bucket

This project provisions:
- S3 bucket for Terraform remote state
- Backend infrastructure for Terraform state management
- State versioning and locking support

### Features
- Remote Terraform state management
- Centralized infrastructure state
- Production-style backend architecture

---

## 06_06_vpc_with_remote_backend

This project provisions:
- AWS VPC
- Public and private subnets
- Internet Gateway
- Route Tables
- Networking infrastructure
- Remote backend integration

### Features
- Reusable Terraform architecture
- AWS networking design
- Infrastructure modularization
- Remote state integration

---

## EKS Infrastructure (Upcoming)

This project will provision:
- Amazon EKS Cluster
- Managed Node Groups
- IAM Roles for Service Accounts (IRSA)
- AWS Load Balancer Controller
- EBS CSI Driver
- Kubernetes Networking
- Autoscaling Infrastructure

### Planned Features
- Production-grade EKS architecture
- GitOps-ready infrastructure
- Kubernetes cluster automation
- Secure IAM integration
- High availability design
- Scalable container platform

---

# Terraform Commands

## Initialize Terraform

```bash
terraform init
```

## Validate Terraform Configuration

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
- Infrastructure state centralization

---

# Best Practices Implemented

- Remote Terraform backend
- Provider version locking
- Infrastructure modularization
- Git version control
- Terraform state isolation
- Clean repository structure
- Infrastructure as Code principles

---

# Files Ignored From Git

The following files/folders are excluded from version control:

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

Planned infrastructure and DevOps projects:
- Amazon EKS
- Helm
- ArgoCD GitOps
- GitHub Actions CI/CD
- AWS Load Balancer Controller
- Route53
- ACM TLS/HTTPS
- Autoscaling
- Prometheus/Grafana Monitoring
- OpenTelemetry
- Kubernetes Ingress
- AWS RDS
- ElastiCache
- DynamoDB
- Terraform Modules

---

# Learning Objectives

This repository was created to strengthen skills in:
- Terraform
- AWS Cloud Infrastructure
- Amazon EKS
- Infrastructure as Code
- Kubernetes Infrastructure
- DevOps Engineering
- GitOps
- Cloud Networking
- State Management

---

# Author

Tina Collins

GitHub:
https://github.com/tcollins520