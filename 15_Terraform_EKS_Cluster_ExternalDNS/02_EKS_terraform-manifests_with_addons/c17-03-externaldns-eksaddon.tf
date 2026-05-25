##############################################
# Discover latest ExternalDNS addon version
##############################################
data "aws_eks_addon_version" "externaldns_latest" {
  addon_name         = "external-dns"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

##############################################
# Install ExternalDNS Add-on
##############################################
resource "aws_eks_addon" "externaldns" {
  depends_on = [
    aws_iam_role.externaldns_role,
    aws_eks_pod_identity_association.externaldns,
    aws_eks_addon.podidentity,
    aws_eks_node_group.private_nodes
  ]  
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "external-dns"
  addon_version               = data.aws_eks_addon_version.externaldns_latest.version

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  service_account_role_arn = aws_iam_role.externaldns_role.arn

  tags = {
    Component   = "ExternalDNS"
    ManagedBy   = "Terraform"
    Project     = local.name
  }
}

##############################################
# Outputs
##############################################
output "externaldns_addon_version" {
  value = aws_eks_addon.externaldns.addon_version
}

output "externaldns_addon_arn" {
  value = aws_eks_addon.externaldns.arn
}

output "externaldns_addon_id" {
  value = aws_eks_addon.externaldns.id
}
