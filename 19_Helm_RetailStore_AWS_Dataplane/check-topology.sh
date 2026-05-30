#!/bin/bash

echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║              POD TOPOLOGY DISTRIBUTION REPORT                              ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Create temporary files for node-zone mapping (macOS bash 3.x compatible)
NODES_FILE=$(mktemp)
kubectl get nodes -o custom-columns=NAME:.metadata.name,ZONE:.metadata.labels.topology\\.kubernetes\\.io/zone --no-headers > "$NODES_FILE"

echo "📍 NODES AND THEIR ZONES:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "%-40s %s\n" "NODE" "ZONE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat "$NODES_FILE" | awk '{printf "%-40s %s\n", $1, $2}' | sort
echo ""

echo "🚀 PODS DISTRIBUTION BY APPLICATION:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "%-12s %-40s %-40s %s\n" "APP" "POD" "NODE" "ZONE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Function to get zone for a node
get_zone() {
  local node=$1
  grep "^$node" "$NODES_FILE" | awk '{print $2}'
}

# Export the function and file path for subshells
export -f get_zone
export NODES_FILE

kubectl get pods -o json | jq -r '
.items[] | 
{
  app: (.metadata.labels."app.kubernetes.io/name" // "unknown"),
  pod: .metadata.name,
  node: .spec.nodeName
} |
[.app, .pod, .node] | @tsv
' | while IFS=$'\t' read -r app pod node; do
  zone=$(get_zone "$node")
  printf "%-12s %-40s %-40s %s\n" "$app" "$pod" "$node" "$zone"
done | sort

echo ""
echo "📊 ZONE DISTRIBUTION SUMMARY:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Get unique app names
APPS=$(kubectl get pods -o jsonpath='{.items[*].metadata.labels.app\.kubernetes\.io/name}' | tr ' ' '\n' | sort -u)

for app in $APPS; do
  echo ""
  echo "📦 $app:"
  
  for zone in us-east-1a us-east-1b us-east-1c; do
    # Count pods in this zone for this app
    count=$(kubectl get pods -l app.kubernetes.io/name=$app -o json | jq -r '
      .items[] | 
      select(.spec.nodeName != null) |
      .spec.nodeName
    ' | while read -r node; do
      get_zone "$node"
    done | grep -c "^$zone$" 2>/dev/null || echo "0")
    
    # Handle the case where count might be empty or invalid
    if [ -z "$count" ] || ! [[ "$count" =~ ^[0-9]+$ ]]; then
      count=0
    fi
    
    # Add visual indicator for zones with pods
    if [ "$count" -gt 0 ]; then
      printf "  %-15s %-2d pods ✅\n" "$zone:" "$count"
    else
      printf "  %-15s %-2d pods ⚠️  (no pods in this zone)\n" "$zone:" "$count"
    fi
  done
done

# Cleanup
rm -f "$NODES_FILE"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Topology spread analysis complete!"
echo ""
echo "💡 INTERPRETATION GUIDE:"
echo "  ✅ = Pods present in this zone (good for HA)"
echo "  ⚠️  = No pods in this zone (may want to investigate)"
echo ""
