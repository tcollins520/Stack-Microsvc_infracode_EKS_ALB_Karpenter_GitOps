# ====================
# IAM POLICIES FOR AMG
# ====================

# Policy 1: Amazon Grafana Prometheus Access Policy
resource "aws_iam_policy" "amg_prometheus_policy" {
  name        = "${local.cluster_name}-amg-prometheus-policy"
  description = "IAM policy for Grafana to access Amazon Managed Prometheus"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "aps:ListWorkspaces",
          "aps:DescribeWorkspace",
          "aps:QueryMetrics",
          "aps:GetLabels",
          "aps:GetSeries",
          "aps:GetMetricMetadata"
        ]
        Resource = "*"
      }
    ]
  })
  tags = var.tags
}

# Policy 2: Amazon Grafana SNS Policy
resource "aws_iam_policy" "amg_sns_policy" {
  name        = "${local.cluster_name}-amg-sns-policy"
  description = "IAM policy for Grafana to publish AWS SNS notifications"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = [
          "arn:aws:sns:*:${local.account_id}:grafana*"
        ]
      }
    ]
  })
  tags = var.tags
}

# Policy 3: AWS X-Ray Read Only Access (AWS Managed Policy - reference only)
data "aws_iam_policy" "xray_readonly" {
  arn = "arn:aws:iam::aws:policy/AWSXrayReadOnlyAccess"
}

