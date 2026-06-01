# Datasource: To get default EKS addon version compatible with EKS cluster version
data "aws_eks_addon_version" "adot_default" {
  addon_name         = "adot"
  kubernetes_version = data.terraform_remote_state.eks.outputs.eks_cluster_version
}

# Datasource: To get latest EKS addon version compatible with EKS cluster version
data "aws_eks_addon_version" "adot_latest" {
  addon_name         = "adot"
  kubernetes_version = data.terraform_remote_state.eks.outputs.eks_cluster_version
  most_recent        = true
}


# EKS Add-on: AWS Distro for OpenTelemetry (ADOT)
resource "aws_eks_addon" "adot" {
  # Cert Manager should be installed and ready before adot eks addon
  depends_on = [aws_eks_addon.cert_manager]  
  cluster_name  = data.terraform_remote_state.eks.outputs.eks_cluster_id
  addon_name    = "adot"
  addon_version = data.aws_eks_addon_version.adot_latest.version
  
  # Configuration for the addon
  configuration_values = jsonencode({
    manager = {
      resources = {
        limits = {
          cpu    = "200m"
          memory = "256Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "64Mi"
        }
      }
    }
    replicaCount = 1
  })
  
  # Conflict resolution
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  tags = var.tags
}


# Outputs
output "adot_addon_id" {
  description = "ADOT EKS Addon ID"
  value       = aws_eks_addon.adot.id
}

output "adot_addon_version" {
  description = "ADOT EKS Addon Version"
  value       = aws_eks_addon.adot.addon_version
}