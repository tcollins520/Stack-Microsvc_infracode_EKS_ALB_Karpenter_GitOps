

# Datasource: To get default EKS addon version compatible with EKS cluster version
data "aws_eks_addon_version" "kube_state_metrics_default" {
  addon_name         = "kube-state-metrics"
  kubernetes_version = data.terraform_remote_state.eks.outputs.eks_cluster_version
}

# Datasource: To get latest EKS addon version compatible with EKS cluster version
data "aws_eks_addon_version" "kube_state_metrics_latest" {
  addon_name         = "kube-state-metrics"
  kubernetes_version = data.terraform_remote_state.eks.outputs.eks_cluster_version
  most_recent        = true
}

# EKS Add-on: Kube State Metrics : This add-on provides detailed metrics about the state of Kubernetes objects in your cluster, such as deployments, pods, and nodes. It helps you monitor the health and performance of your cluster by exposing these metrics to Amazon CloudWatch or other monitoring tools.
resource "aws_eks_addon" "kube_state_metrics" {
  cluster_name  = data.terraform_remote_state.eks.outputs.eks_cluster_id
  addon_name    = "kube-state-metrics"
  addon_version = data.aws_eks_addon_version.kube_state_metrics_latest.version  
  # Conflict resolution
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  tags = var.tags
}


# Outputs
output "kube_state_metrics_addon_id" {
  description = "Kube State Metrics EKS Addon ID"
  value       = aws_eks_addon.kube_state_metrics.id
}

output "kube_state_metrics_version" {
  description = "Kube State Metrics EKS Addon Version"
  value       = aws_eks_addon.kube_state_metrics.addon_version
}
