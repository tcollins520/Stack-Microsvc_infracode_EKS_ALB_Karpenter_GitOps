# Amazon Managed Service for Prometheus Workspace
resource "aws_prometheus_workspace" "amp" {
  alias = "${local.cluster_name}-amp"  
  tags = var.tags
}

# Output for use in collectors
output "amp_workspace_id" {
  description = "AMP Workspace ID"
  value       = aws_prometheus_workspace.amp.id
}

output "amp_endpoint" {
  description = "AMP Remote Write Endpoint"
  value       = "${aws_prometheus_workspace.amp.prometheus_endpoint}api/v1/remote_write"
}

output "amp_query_endpoint" {
  description = "AMP Query Endpoint"
  value       = "${aws_prometheus_workspace.amp.prometheus_endpoint}api/v1/query"
}
