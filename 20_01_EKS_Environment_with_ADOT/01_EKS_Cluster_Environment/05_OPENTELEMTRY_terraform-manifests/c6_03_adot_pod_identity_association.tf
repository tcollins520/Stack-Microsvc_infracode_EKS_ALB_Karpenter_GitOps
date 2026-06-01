# ADOT Collector Pod Identity Association
resource "aws_eks_pod_identity_association" "adot_collector" {
  cluster_name    = data.terraform_remote_state.eks.outputs.eks_cluster_name
  namespace       = "default"
  service_account = "adot-collector"
  role_arn        = aws_iam_role.adot_collector.arn
  tags = var.tags
}