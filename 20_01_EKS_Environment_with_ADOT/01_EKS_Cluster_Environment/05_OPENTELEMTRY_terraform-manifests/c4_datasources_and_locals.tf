# Data Source: AWS Account Info
data "aws_caller_identity" "current" {}

# Data Source: AWS Region
data "aws_region" "current" {}

# Data Source: AWS Partition
data "aws_partition" "current" {}

# --------------------------------------------------------------------
# Local values used throughout the EKS configuration
# Helps enforce naming consistency and reduce duplication
# --------------------------------------------------------------------
locals {
  # Business division or team name (from variable)
  owners = var.business_division  # Example: "retail"

  # Environment name such as dev, staging, prod (from variable)
  environment = var.environment_name  # Example: "dev"

  # Standardized naming prefix: "<division>-<env>"
  name = "${local.owners}-${local.environment}"  # Example: "retail-dev"

  # AWS Account ID
  account_id = data.aws_caller_identity.current.account_id

  # AWS Partition
  partition = data.aws_partition.current.partition

  # VPC Outputs
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  # EKS Cluster Outputs
  cluster_name                         = data.terraform_remote_state.eks.outputs.eks_cluster_name
}

