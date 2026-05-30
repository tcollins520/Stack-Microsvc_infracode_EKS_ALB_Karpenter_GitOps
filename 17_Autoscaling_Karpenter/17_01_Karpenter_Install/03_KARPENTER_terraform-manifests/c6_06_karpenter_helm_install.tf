resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = "1.8.2"
  namespace  = "kube-system"
  create_namespace = false

  set = [
    # EKS Cluster Name
    {
    name  = "settings.clusterName"
    value = data.terraform_remote_state.eks.outputs.eks_cluster_name
    },
    # EKS Cluster Endpoint
    {
    name  = "settings.clusterEndpoint"
    value = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
    },
    # Interruption Queue
    {
    name  = "settings.interruptionQueue"
    value = aws_sqs_queue.karpenter_interruption.name
    },    
    # This is the only required one
    {
      name  = "serviceAccount.name"
      value = "karpenter"
    },
    # Karpenter ServiceAccount
    {
      name  = "serviceAccount.create"
      value = "true"
    }
  ]

  # Very Important: Ensure IAM Role + Pod Identity are created BEFORE Helm deploys Karpenter
  depends_on = [
    aws_iam_role.karpenter_controller,
    aws_iam_policy.karpenter_controller,
    aws_iam_role_policy_attachment.karpenter_controller_attach,
    aws_eks_pod_identity_association.karpenter,
    aws_eks_access_entry.karpenter_node_access,
    aws_sqs_queue.karpenter_interruption
  ]  
}

# Outputs
output "karpenter_helm_metadata" {
  description = "Metadata for Karpenter Controller Helm release"
  value       = helm_release.karpenter.metadata
}
