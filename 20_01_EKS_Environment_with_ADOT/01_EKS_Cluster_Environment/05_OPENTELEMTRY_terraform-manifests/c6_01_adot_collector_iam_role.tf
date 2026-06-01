data "aws_iam_policy_document" "adot_collector_assume" {
  statement {
    sid = "PodIdentity"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}


# ADOT Collector IAM Role for Pod Identity
# IAM Role - ADOT Collector
resource "aws_iam_role" "adot_collector" {
  name = "${local.cluster_name}-adot-collector-role"
  assume_role_policy = data.aws_iam_policy_document.adot_collector_assume.json
}

# Outputs
output "adot_collector_role_arn" {
  description = "IAM Role ARN for ADOT Collector"
  value       = aws_iam_role.adot_collector.arn
}
