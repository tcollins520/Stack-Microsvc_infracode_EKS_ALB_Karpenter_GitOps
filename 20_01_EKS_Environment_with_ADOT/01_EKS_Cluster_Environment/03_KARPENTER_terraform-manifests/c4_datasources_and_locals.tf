# Data Source: AWS Account Info
data "aws_caller_identity" "current" {}

# Data Source: AWS Region
data "aws_region" "current" {}

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

  # Cluster Name
  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name
}

