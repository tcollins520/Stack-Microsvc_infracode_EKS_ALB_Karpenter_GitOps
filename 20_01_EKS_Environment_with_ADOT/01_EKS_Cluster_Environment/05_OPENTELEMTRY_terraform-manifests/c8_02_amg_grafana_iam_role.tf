# IAM ROLE FOR AMG
resource "aws_iam_role" "amg_iam_role" {
  name               = "${local.cluster_name}-amg-service-role"
  description        = "IAM role for Amazon Managed Grafana"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "grafana.amazonaws.com"
        }
      },
    ]
  })
  tags = var.tags
}

# Attach Policy 1: Prometheus Access
resource "aws_iam_role_policy_attachment" "amg_prometheus_policy_attachment" {
  role       = aws_iam_role.amg_iam_role.name
  policy_arn = aws_iam_policy.amg_prometheus_policy.arn
}

# Attach Policy 2: SNS Access
resource "aws_iam_role_policy_attachment" "amg_sns_policy_attachment" {
  role       = aws_iam_role.amg_iam_role.name
  policy_arn = aws_iam_policy.amg_sns_policy.arn
}

# Attach Policy 3: X-Ray Read Only (AWS Managed)
resource "aws_iam_role_policy_attachment" "amg_xray_readonly_attachment" {
  role       = aws_iam_role.amg_iam_role.name
  policy_arn = data.aws_iam_policy.xray_readonly.arn
}

# IAM Role
output "amg_iam_role_arn" {
  description = "ARN of the AMG IAM role"
  value       = aws_iam_role.amg_iam_role.arn
}

output "amg_iam_role_name" {
  description = "Name of the AMG service role"
  value       = aws_iam_role.amg_iam_role.name
}