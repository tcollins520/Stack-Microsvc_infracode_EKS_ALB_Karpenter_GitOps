resource "aws_eks_pod_identity_association" "karpenter" {
  cluster_name    = data.terraform_remote_state.eks.outputs.eks_cluster_name
  namespace       = "kube-system"
  service_account = "karpenter"
  role_arn        = aws_iam_role.karpenter_controller.arn
}

# Output
output "karpenter_controller_pod_identity_association" {
  description = "Pod Identity association ID for the Karpenter controller"
  value       = aws_eks_pod_identity_association.karpenter.id
}