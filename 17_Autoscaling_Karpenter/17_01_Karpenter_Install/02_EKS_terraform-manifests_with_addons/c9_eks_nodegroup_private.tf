# EKS Managed Node Group - Private Subnets
resource "aws_eks_node_group" "private_nodes" {

  # The name of the EKS cluster this node group belongs to
  cluster_name = aws_eks_cluster.main.name

  # Logical name for this node group in the EKS cluster
  node_group_name = "${local.name}-private-ng"

  # IAM role that EC2 worker nodes will assume
  node_role_arn = aws_iam_role.eks_nodegroup_role.arn

  # Subnets where the worker nodes will be launched (typically private subnets)
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  # Instance types for the nodes (e.g., t3.medium, m5.large)
  instance_types = var.node_instance_types

  # Choose between ON_DEMAND or SPOT capacity types
  capacity_type = var.node_capacity_type

  # Use Amazon Linux 2023 AMI — the latest Amazon-managed OS optimized for EKS
  # Fully supported in Kubernetes v1.25+ and production-ready
  # Better security, updated packages, and long-term support (recommended over AL2)
  ami_type = "AL2023_x86_64_STANDARD"

  # Root volume size for each node (in GiB)
  disk_size = var.node_disk_size

  # Configure auto-scaling limits and defaults
  scaling_config {
    # Desired number of nodes when the node group is created
    desired_size = 3

    # Minimum number of nodes allowed
    min_size = 1

    # Maximum number of nodes the group can scale to
    max_size = 6
  }

  # Set the max percentage of nodes that can be unavailable during update
  update_config {
    max_unavailable_percentage = 33
  }

  # Force node group update when EKS AMI version changes
  force_update_version = true

  # Apply labels to each EC2 instance for easier scheduling and management in Kubernetes
  labels = {
    "env"  = var.environment_name
    "team" = var.business_division
  }

  # Tags for the node group and associated EC2 instances
  tags = merge(var.tags, {
    # Standard EC2 name tag
    Name = "${local.name}-private-ng"

    # Logical environment (e.g., dev, prod)
    Environment = var.environment_name
  })

  # Ensure IAM role policies are attached before creating the node group
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy
  ]
}
