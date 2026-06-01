# ADOT Collector IAM Policy
resource "aws_iam_policy" "adot_collector" {
  name        = "${local.name}-adot-collector-policy"
  description = "IAM policy for ADOT collector to send telemetry to CloudWatch and X-Ray"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # CloudWatch Logs Permissions (Write)
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups"
        ]
        Resource = [
          "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/*",
          "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/*:*"
        ]
      },
      # CloudWatch Logs Permissions (Read - for querying/debugging)
      {
        Effect = "Allow"
        Action = [
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ]
        Resource = [
          "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/*",
          "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/*:*"
        ]
      },
      # CloudWatch Metrics Permissions
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      },
      # X-Ray Permissions
      {
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets",
          "xray:GetSamplingStatisticSummaries"
        ]
        Resource = "*"
      },
      # Amazon Managed Prometheus permissions    
      {
        Effect = "Allow"
        Action = [
          "aps:RemoteWrite",
          "aps:QueryMetrics",
          "aps:GetSeries",
          "aps:GetLabels",
          "aps:GetMetricMetadata"
        ]
        Resource = aws_prometheus_workspace.amp.arn
      }      
    ]
  })

  tags = var.tags
}

# Attach IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "adot_collector" {
  policy_arn = aws_iam_policy.adot_collector.arn
  role       = aws_iam_role.adot_collector.name
}