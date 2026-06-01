# AMAZON MANAGED GRAFANA WORKSPACE
resource "aws_grafana_workspace" "main" {
  name                     = "${local.cluster_name}-amg"
  description              = "Grafana workspace for ${local.cluster_name} EKS cluster monitoring"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]  # AWS Identity Center
  permission_type          = "CUSTOMER_MANAGED"
  role_arn                 = aws_iam_role.amg_iam_role.arn

  # Data sources that Grafana can query
  data_sources = ["PROMETHEUS", "CLOUDWATCH", "XRAY"]

  # Notification destinations
  notification_destinations = ["SNS"]

  # Network access: Open (as of not VPC-restricted)
  # For VPC access, add vpc_configuration block

  # Workspace configuration
  configuration = jsonencode({
    plugins = {
      pluginAdminEnabled = true
    }
    unifiedAlerting = {
      enabled = true
    }
  })
  tags = var.tags
}

# AMG Workspace
output "amg_workspace_id" {
  description = "ID of the Grafana workspace"
  value       = aws_grafana_workspace.main.id
}

output "amg_workspace_arn" {
  description = "ARN of the Grafana workspace"
  value       = aws_grafana_workspace.main.arn
}

output "amg_workspace_endpoint" {
  description = "Endpoint URL for the Grafana workspace"
  value       = aws_grafana_workspace.main.endpoint
}


output "amg_workspace_url" {
  description = "Full URL to access Grafana workspace"
  value       = "https://${aws_grafana_workspace.main.endpoint}"
}

