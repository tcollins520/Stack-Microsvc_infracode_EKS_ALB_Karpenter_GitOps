# --------------------------------------------------------------------
# Reference the Remote State from EKS Project
# --------------------------------------------------------------------
data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "tfstate-dev-us-east-1-bl6qlh"     # Name of the remote S3 bucket where the EKS state is stored
    key    = "eks/dev/terraform.tfstate"        # Path to the EKS tfstate file within the bucket
    region = var.aws_region                    # Region where the S3 bucket exist
  }
}

# --------------------------------------------------------------------
# Output the EKS eks_cluster_name and eks_cluster_id from the remote EKS state
# --------------------------------------------------------------------
output "eks_cluster_name" {
  value = data.terraform_remote_state.eks.outputs.eks_cluster_name
}

output "eks_cluster_id" {
  value = data.terraform_remote_state.eks.outputs.eks_cluster_id
}
