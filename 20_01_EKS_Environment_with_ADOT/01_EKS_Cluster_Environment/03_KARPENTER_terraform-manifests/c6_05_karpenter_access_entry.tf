resource "aws_eks_access_entry" "karpenter_node_access" {
  depends_on = [data.terraform_remote_state.eks]
  cluster_name  = data.terraform_remote_state.eks.outputs.eks_cluster_name
  principal_arn = aws_iam_role.karpenter_node.arn
  type          = "EC2_LINUX"
}
