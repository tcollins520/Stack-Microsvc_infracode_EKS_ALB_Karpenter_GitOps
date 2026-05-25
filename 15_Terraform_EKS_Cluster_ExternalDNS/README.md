# 15. External DNS Install using Terraform

## Step-01: Introduction
In this step, we’re bringing in ExternalDNS, the service that automatically updates Route53 whenever your Kubernetes Services or Ingresses need DNS records. No manual work, no copy-pasting hostnames, no stress.

We’ll install ExternalDNS as an EKS Add-On using Terraform, wire it up with Pod Identity, and make sure it has the exact Route53 permissions it needs. Once this is in place, your cluster will straight-up manage DNS on its own like a pro.

---
### Architecture - AWS EKS cluster with External DNS 
![Architecture - EKS Cluster with EKS Cluster](../images/15_Architecture_EKS_Cluster_with_ExternalDNS_EKSaddon.png)

### AWS EKS Cluster with External DNS
![EKS Cluster with EKS Cluster](../images/15_EKS_Cluster_with_ExternalDNS_EKSaddon.png)


![RetailStore Application with Ingress and External DNS](../images/16_01_RetailStore_Ingress_ExternalDNS.png)


![RetailStore Application with Ingress and External DNS](../images/16_02_RetailStore_Ingress_ExternalDNS.png)

---

## Step-02: Copy VPC and EKS TF Projects from Section-13 and Add External DNS TF Code in EKS Terraform Project
- [Section-13](../13_Terraform_EKS_Cluster_with_AddOns/)
- [VPC Terraform Project](../13_Terraform_EKS_Cluster_with_AddOns/01_VPC_terraform-manifests/)
- [EKS Terraform Project](../13_Terraform_EKS_Cluster_with_AddOns/02_EKS_terraform-manifests_with_addons/)

---

## Step-03: Review External DNS Terraform Files 
**Folder Location:** 02_EKS_terraform-manifests_with_addons
1. c17-01-externaldns-iam-policy-and-role.tf
2. c17-02-externaldns-pod-identity-association.tf
3. c17-03-externaldns-eksaddon.tf

---

## Step-04: Execute Terraform Commands to Install ExternalDNS
```bash
# VERY VERY IMPORTANT NOTE
# Update the backend bucket with your S3 bucket
vpc/c1-versions.tf
eks/c1_versions.tf
eks/c3_remote-state.tf

# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve
```

---

## Step-05: Verify ExternalDNS Install
```bash
# List AWS EKS Addon Command
aws eks list-addons --cluster-name retail-dev-eksdemo1

# List Deployments
kubectl -n external-dns get deploy 

# List Pods
kubectl -n external-dns get pods 

# Verify External DNS Pod logs
kubectl -n external-dns logs -f -l app.kubernetes.io/name=external-dns
```

---
