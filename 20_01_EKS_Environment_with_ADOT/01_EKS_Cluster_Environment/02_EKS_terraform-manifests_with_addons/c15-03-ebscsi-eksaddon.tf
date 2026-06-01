# Datasource: Get the default EBS CSI addon version compatible with EKS version
data "aws_eks_addon_version" "ebs_csi_default" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = aws_eks_cluster.main.version
}

# Datasource: Get the latest available EBS CSI addon version
data "aws_eks_addon_version" "ebs_csi_latest" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

# Resource: Install EBS CSI Driver addon
resource "aws_eks_addon" "ebs_csi" {
  depends_on = [
    aws_iam_role.ebs_csi_iam_role,
    aws_eks_pod_identity_association.ebs_csi,
    aws_eks_addon.podidentity,
    aws_eks_node_group.private_nodes
  ]
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = data.aws_eks_addon_version.ebs_csi_latest.version

  service_account_role_arn    = aws_iam_role.ebs_csi_iam_role.arn

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Name        = "${local.name}-aws-ebs-csi-addon"
    Environment = var.environment_name
    Component   = "Amazon EBS CSI Driver"
  }
}


# Outputs
output "ebs_csi_addon_default_version" {
  description = "Default EBS CSI addon version compatible with the EKS cluster version"
  value       = data.aws_eks_addon_version.ebs_csi_default.version
}

output "ebs_csi_addon_latest_version" {
  description = "Latest available EBS CSI addon version for the current EKS cluster"
  value       = data.aws_eks_addon_version.ebs_csi_latest.version
}

output "ebs_csi_addon_arn" {
  description = "ARN of the installed EBS CSI addon"
  value       = aws_eks_addon.ebs_csi.arn
}

output "ebs_csi_addon_id" {
  description = "ID of the installed EBS CSI addon"
  value       = aws_eks_addon.ebs_csi.id
}
