#!/bin/bash
set -e

echo "==============================="
echo "STEP-1: Create VPC using Terraform"
echo "==============================="
cd 01_VPC_terraform-manifests
terraform init 
terraform apply -auto-approve

echo
echo "==============================="
echo "STEP-2: Create EKS Cluster using Terraform"
echo "==============================="
cd ../02_EKS_terraform-manifests_with_addons
terraform init 
terraform apply -auto-approve

echo
echo "==============================="
echo "STEP-2.1: Authenticate with AWS ECR Public"
echo "==============================="
echo "Authenticating with AWS ECR Public for Karpenter Helm chart..."

if aws ecr-public get-login-password --region us-east-1 | \
   helm registry login --username AWS --password-stdin public.ecr.aws; then
    echo "✅ Successfully authenticated with AWS ECR Public"
else
    echo "❌ Failed to authenticate with AWS ECR Public"
    echo "Please check your AWS credentials and try again"
    exit 1
fi

echo
echo "==============================="
echo "STEP-3: Install Karpenter using Terraform"
echo "==============================="
cd ../03_KARPENTER_terraform-manifests
terraform init
terraform apply -auto-approve

echo
echo "==============================="
echo "STEP-4: Configure kubeconfig"
echo "==============================="

# Get the complete kubeconfig command from terraform outputs
cd ../02_EKS_terraform-manifests_with_addons
KUBECONFIG_CMD=$(terraform output -raw to_configure_kubectl)

echo "Executing: $KUBECONFIG_CMD"
eval $KUBECONFIG_CMD

echo "✅ Kubeconfig configured successfully!"

echo
echo "==============================="
echo "STEP-4.1: Verify kubeconfig connectivity"
echo "==============================="

# Verify kubeconfig is working by checking nodes
echo "Verifying EKS cluster connectivity..."
if kubectl get nodes > /dev/null 2>&1; then
    echo "✅ Successfully connected to EKS cluster!"
    echo "Current nodes in the cluster:"
    kubectl get nodes
else
    echo "❌ Failed to connect to EKS cluster. Please check your kubeconfig configuration."
    exit 1
fi

# Verify we can access the cluster info
echo
echo "Cluster Info:"
kubectl cluster-info

echo
echo "==============================="
echo "STEP-5: Apply Karpenter EC2NodeClass"
echo "==============================="
cd ../04_KARPENTER_k8s-manifests
kubectl apply -f 01_ec2nodeclass.yaml

# Wait for EC2NodeClass to be ready
echo "Waiting for EC2NodeClass to be ready..."
sleep 10

echo
echo "==============================="
echo "STEP-6: Apply Karpenter OnDemand NodePool"
echo "==============================="
kubectl apply -f 02_nodepool_ondemand.yaml

# Wait for OnDemand NodePool to be ready
echo "Waiting for OnDemand NodePool to be ready..."
sleep 10

echo
echo "==============================="
echo "STEP-7: Apply Karpenter Spot NodePool"
echo "==============================="
kubectl apply -f 03_nodepool_spot.yaml

# Wait for Spot NodePool to be ready
echo "Waiting for Spot NodePool to be ready..."
sleep 10

echo
echo "✅ All Karpenter manifests applied successfully!"

echo
echo "==============================="
echo "SUMMARY"
echo "==============================="
echo "✅ VPC created successfully"
echo "✅ EKS Cluster created successfully"
echo "✅ ECR Public authentication completed"
echo "✅ Karpenter installed via Terraform"
echo "✅ Kubeconfig configured"
echo "✅ EC2NodeClass applied"
echo "✅ OnDemand NodePool applied"
echo "✅ Spot NodePool applied"
echo
echo "Your EKS Cluster with Karpenter is now fully configured and ready to use!"
echo "==============================="