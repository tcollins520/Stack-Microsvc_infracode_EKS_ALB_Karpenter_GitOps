#!/usr/bin/env bash
# Restart all Retail Store microservice deployments

# Optional: pass namespace as first argument (defaults to "default")
NAMESPACE="${1:-default}"

echo "🔁 Restarting RetailStore deployments in namespace: $NAMESPACE"

kubectl rollout restart deploy catalog  -n "$NAMESPACE"
kubectl rollout restart deploy carts    -n "$NAMESPACE"
kubectl rollout restart deploy checkout -n "$NAMESPACE"
kubectl rollout restart deploy orders   -n "$NAMESPACE"
kubectl rollout restart deploy ui       -n "$NAMESPACE"

echo "✅ Restart triggered for catalog, carts, checkout, orders, ui"
