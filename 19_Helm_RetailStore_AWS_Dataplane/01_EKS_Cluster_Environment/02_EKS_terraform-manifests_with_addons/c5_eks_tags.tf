# -------------------------------------------------------------------
# IMPORTANT NOTE ABOUT SUBNET TAGS:
#
# For EKS clusters, subnets may be tagged as either "shared" or "owned":
#
#   - "shared"  => The EKS control plane can use the subnet, but 
#                  WORKER NODES CANNOT be launched here.
#
#   - "owned"   => The subnet is fully owned by this EKS cluster and 
#                  **EC2 worker nodes / Karpenter NodeClaims can be created here.**
#
# Karpenter, Managed Node Groups, and Cluster Autoscaler REQUIRE 
# "owned" subnets so they can launch EC2 instances and attach ENIs.
#
# In this project, we set all EKS subnets to **owned** to ensure
# Karpenter can provision nodes successfully.
# -------------------------------------------------------------------


# -------------------------------------------------------------------
# Public Subnet Tags for EKS Load Balancer Support
# -------------------------------------------------------------------

resource "aws_ec2_tag" "eks_subnet_tag_public_elb" {
  for_each    = toset(data.terraform_remote_state.vpc.outputs.public_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "eks_subnet_tag_public_cluster" {
  for_each    = toset(data.terraform_remote_state.vpc.outputs.public_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${local.eks_cluster_name}"
  value       = "owned"   # CHANGED FROM 'shared'
}

# -------------------------------------------------------------------
# Private Subnet Tags for EKS Internal LoadBalancer Support
# -------------------------------------------------------------------

resource "aws_ec2_tag" "eks_subnet_tag_private_elb" {
  for_each    = toset(data.terraform_remote_state.vpc.outputs.private_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

resource "aws_ec2_tag" "eks_subnet_tag_private_cluster" {
  for_each    = toset(data.terraform_remote_state.vpc.outputs.private_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${local.eks_cluster_name}"
  value       = "owned"   # CHANGED FROM 'shared'
}
