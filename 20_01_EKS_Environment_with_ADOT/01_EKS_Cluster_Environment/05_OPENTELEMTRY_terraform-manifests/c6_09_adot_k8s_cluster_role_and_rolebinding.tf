# ADOT Collector RBAC Resources
# Purpose: Grant OpenTelemetry Collector permissions to scrape metrics from Kubernetes API
resource "kubernetes_service_account_v1" "adot_collector" {
  metadata {
    name      = "adot-collector"
    namespace = "default"
    labels = {
      "app.kubernetes.io/name"      = "adot-collector"
      "app.kubernetes.io/component" = "opentelemetry-collector"
    }
  }
}

# Kubernetes Cluster Role
resource "kubernetes_cluster_role_v1" "otel_collector" {
  metadata {
    name = "otel-collector-cluster-role"
  }

  # Core Kubernetes resources
  rule {
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "services", "endpoints", "pods", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }

  # Apps resources
  rule {
    api_groups = ["apps"]
    resources  = ["replicasets", "deployments", "daemonsets", "statefulsets"]
    verbs      = ["get", "list", "watch"]
  }

  # Extensions resources
  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }

  # Metrics endpoint
  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }
}

# Kubernetes Cluster Role Binding
resource "kubernetes_cluster_role_binding_v1" "otel_collector" {
  metadata {
    name = "otel-collector-cluster-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.otel_collector.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.adot_collector.metadata[0].name
    namespace = kubernetes_service_account_v1.adot_collector.metadata[0].namespace
  }
}