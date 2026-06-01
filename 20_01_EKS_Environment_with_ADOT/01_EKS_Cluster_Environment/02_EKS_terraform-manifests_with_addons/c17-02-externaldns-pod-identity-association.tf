##############################################
# ExternalDNS Pod Identity Association
##############################################
resource "aws_eks_pod_identity_association" "externaldns" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "external-dns"
  service_account = "external-dns"
  role_arn        = aws_iam_role.externaldns_role.arn
}

##############################################
# Output
##############################################
output "externaldns_pod_identity_association_id" {
  value = aws_eks_pod_identity_association.externaldns.id
}
