#!/bin/bash
set -e

echo "==============================="
echo "STEP-1: Check kubeconfig"
echo "==============================="

if ! kubectl cluster-info > /dev/null 2>&1; then
    echo "❌ ERROR: Could not connect to EKS cluster"
    echo "⚠️  If cluster is already destroyed, you can skip the Kubernetes resource cleanup"
    echo "   and proceed directly with Terraform destroy"
    exit 1
fi

echo "✅ Connected to EKS cluster"

echo
echo "==============================="
echo "STEP-2: Check for Karpenter nodes"
echo "==============================="

KARPENTER_NODES=$(kubectl get nodes -l karpenter.k8s.aws/ec2nodeclass=default-ec2nodeclass 2>/dev/null | grep -v "NAME" | wc -l)

if [ $KARPENTER_NODES -gt 0 ]; then
    echo "❌ ERROR: Found $KARPENTER_NODES Karpenter node(s) still running!"
    echo
    echo "Current Karpenter nodes:"
    kubectl get nodes -l karpenter.k8s.aws/ec2nodeclass=default-ec2nodeclass
    echo
    echo "⚠️  Please delete all workloads and NodePools manually, then retry"
    exit 1
fi

echo "✅ No Karpenter nodes - Safe to proceed"

echo
echo "==============================="
echo "STEP-3: Delete Spot NodePool"
echo "==============================="
cd 04_KARPENTER_k8s-manifests
kubectl delete -f 03_nodepool_spot.yaml --ignore-not-found
echo "✅ Spot NodePool deleted"

echo
echo "==============================="
echo "STEP-4: Delete OnDemand NodePool"
echo "==============================="
kubectl delete -f 02_nodepool_ondemand.yaml --ignore-not-found
echo "✅ OnDemand NodePool deleted"

echo
echo "==============================="
echo "STEP-5: Delete EC2NodeClass"
echo "==============================="
kubectl delete -f 01_ec2nodeclass.yaml --ignore-not-found
echo "✅ EC2NodeClass deleted"

echo
echo "==============================="
echo "STEP-5.1: Authenticate with AWS ECR Public"
echo "==============================="
echo "Authenticating with AWS ECR Public for Karpenter Helm chart..."

if aws ecr-public get-login-password --region us-east-1 | \
   helm registry login --username AWS --password-stdin public.ecr.aws; then
    echo "✅ Successfully authenticated with AWS ECR Public"
else
    echo "❌ Failed to authenticate with AWS ECR Public"
    echo "⚠️  This is required for Terraform to properly destroy the Helm release"
    echo "Please check your AWS credentials and try again"
    exit 1
fi

echo
echo "==============================="
echo "STEP-6: Destroy Karpenter Terraform"
echo "==============================="
cd ../03_KARPENTER_terraform-manifests
terraform init
terraform destroy -auto-approve
rm -rf .terraform .terraform.lock.hcl
echo "✅ Karpenter Terraform destroyed"

echo
echo "==============================="
echo "STEP-7: Destroy EKS Cluster"
echo "==============================="
cd ../02_EKS_terraform-manifests_with_addons
terraform init
terraform destroy -auto-approve
rm -rf .terraform .terraform.lock.hcl
echo "✅ EKS Cluster destroyed"

echo
echo "==============================="
echo "STEP-8: Destroy VPC"
echo "==============================="
cd ../01_VPC_terraform-manifests
terraform init
terraform destroy -auto-approve
rm -rf .terraform .terraform.lock.hcl
echo "✅ VPC destroyed"

echo
echo "==============================="
echo "✅ DESTRUCTION COMPLETE"
echo "==============================="