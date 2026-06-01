Terraform AWS Infrastructure (IaC)

Production-style Infrastructure as Code (IaC) projects built with Terraform on AWS.

This repository contains Terraform projects focused on:

* AWS infrastructure provisioning
* Remote backend configuration
* Amazon VPC networking
* Amazon EKS infrastructure
* Kubernetes platform foundations
* AWS Load Balancer Controller
* Kubernetes ingress (HTTP/HTTPS)
* Terraform state management
* Infrastructure automation
* DevOps and Cloud Engineering best practices
* Technologies Used
* Terraform
* AWS
* Amazon EKS
* Kubernetes
* Amazon VPC
* Amazon S3
* DynamoDB
* IAM
* AWS Load Balancer Controller
* Helm
* GitHub
* Infrastructure as Code (IaC)
* 
This project provisions:

AWS VPC
Public and private subnets
Internet Gateway
NAT Gateway
Route Tables
Networking infrastructure
Remote backend integration
Features
Reusable Terraform architecture
AWS networking design
Infrastructure modularization
High availability networking
Remote state integration
07_Terraform_EKS_Cluster

This project provisions:

Amazon EKS Cluster
Managed Node Groups
Private Kubernetes Worker Nodes
IAM Roles for Service Accounts (IRSA)
Kubernetes Authentication
EKS Networking Integration
Terraform-based Kubernetes Infrastructure
Features
Production-style EKS architecture
Kubernetes cluster provisioning using Terraform
Managed node groups in private subnets
IAM and RBAC integration
kubectl authentication and access
Remote Terraform backend integration
Cloud-native infrastructure design
Completed Validation
Verified worker node registration
Verified Kubernetes system pods
Verified CoreDNS
Verified kube-proxy
Verified AWS VPC CNI
Verified Kubernetes RBAC access
Verified kubectl connectivity
08_Kubernetes_Foundation

This section focuses on foundational Kubernetes platform components.

Planned Components
Metrics Server
Kubernetes Namespaces
Resource Quotas
Horizontal Pod Autoscaler (HPA)
Kubernetes RBAC
Cluster resource management
Goals
Kubernetes platform administration
Resource monitoring
Autoscaling configuration
Kubernetes operational foundations
09_Kubernetes_Secrets

This section focuses on Kubernetes secret management and secure application configuration.

Planned Components
Kubernetes Secrets
ConfigMaps
Environment variable management
Secure application configuration
Secret injection into workloads
Goals
Kubernetes security practices
Secure application deployment
Configuration management
10_Kubernetes_Storage

This section focuses on Kubernetes persistent storage.

Planned Components
Persistent Volumes (PV)
Persistent Volume Claims (PVC)
Storage Classes
AWS EBS CSI Driver
Dynamic volume provisioning
Goals
Stateful Kubernetes workloads
Persistent application storage
Storage automation
11_Kubernetes_Ingress

This section focuses on external application exposure and Kubernetes ingress management.

11_01_LoadBalancer_Controller_Install

This project will implement:

AWS Load Balancer Controller
IAM Roles for Service Accounts (IRSA)
OIDC integration
AWS ALB integration
Kubernetes ingress support
Goals
Production-grade ingress architecture
AWS-native ingress integration
Secure Kubernetes ingress management
11_02_Kubernetes_Ingress_http

This project will implement:

HTTP ingress resources
Application routing
AWS Application Load Balancer integration
External traffic exposure
Goals
Kubernetes ingress routing
External application access
Layer 7 traffic management
11_03_Kubernetes_Ingress_https

This project will implement:

HTTPS ingress configuration
TLS/SSL certificates
AWS Certificate Manager (ACM)
Secure application exposure
Goals
Secure Kubernetes ingress
HTTPS traffic encryption
Production-grade application security
Terraform Commands
Initialize Terraform
terraform init
Validate Terraform Configuration
terraform validate
Format Terraform Files
terraform fmt
Preview Infrastructure Changes
terraform plan
Deploy Infrastructure
terraform apply
Destroy Infrastructure
terraform destroy
Kubernetes Commands
Configure kubectl for Amazon EKS
aws eks --region us-east-1 update-kubeconfig --name retail-dev-eks
Verify Worker Nodes
kubectl get nodes
Verify Kubernetes System Pods
kubectl get pods -A
Verify Kubernetes RBAC Access
kubectl auth can-i get nodes
Terraform Backend

This repository demonstrates:

Remote Terraform backend configuration
S3 backend storage
Terraform state locking
Infrastructure state management best practices
Centralized infrastructure state
Best Practices Implemented
Remote Terraform backend
Provider version locking
Infrastructure modularization
Git version control
Terraform state isolation
Clean repository structure
Infrastructure as Code principles
Kubernetes infrastructure automation
Cloud-native architecture
Files Ignored From Git

The following files/folders are excluded from version control:

.terraform/
*.tfstate
*.tfstate.*
terraform.tfvars
crash.log
Prerequisites

Before running this project, ensure you have:

AWS Account
AWS CLI configured
Terraform installed
kubectl installed
Git installed
Configure AWS Credentials
aws configure
Verify Terraform Installation
terraform version
Verify kubectl Installation
kubectl version --client
Future Enhancements

Planned infrastructure and DevOps projects:

ArgoCD GitOps
GitHub Actions CI/CD
Helm deployments
Route53 integration
ExternalDNS
Prometheus monitoring
Grafana dashboards
OpenTelemetry
Karpenter autoscaling
AWS RDS
ElastiCache
DynamoDB
Advanced Terraform modules
Multi-environment infrastructure
Learning Objectives

This repository was created to strengthen skills in:

Terraform
AWS Cloud Infrastructure
Amazon EKS
Kubernetes Administration
Infrastructure as Code
Kubernetes Infrastructure
DevOps Engineering
GitOps
Cloud Networking
Terraform State Management
Kubernetes Security
Platform Engineering
Author

Tina Collins
