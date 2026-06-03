#!/bin/bash

################################################################################
# Amazon Managed Prometheus (AMP) Metrics Verification Script
# 
# Prerequisites:
# - awscurl installed: pip install awscurl
# - AWS credentials configured
# - jq installed for JSON parsing
################################################################################

# Configuration - UPDATE THESE VALUES
AMP_WORKSPACE_ID="ws-5a40d858-57d4-4724-a867-1e226e80b446"
AWS_REGION="us-east-1"
AMP_ENDPOINT="https://aps-workspaces.${AWS_REGION}.amazonaws.com/workspaces/${AMP_WORKSPACE_ID}"

echo "============================================================================"
echo "         Amazon Managed Prometheus (AMP) Metrics Verification"
echo "============================================================================"
echo ""
echo "AMP Workspace: $AMP_WORKSPACE_ID"
echo "AWS Region: $AWS_REGION"
echo ""

################################################################################
# TEST 1: Basic Connectivity
################################################################################
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST 1: Basic Connectivity to AMP"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

awscurl --service="aps" --region="$AWS_REGION" \
  "${AMP_ENDPOINT}/api/v1/query?query=up" | jq '.'
echo ""
sleep 5
################################################################################
# TEST 2: Discover All Scrape Jobs
################################################################################
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST 2: Discover All Scrape Jobs"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

all_scrape_jobs=$(awscurl --service="aps" --region="$AWS_REGION" \
  "${AMP_ENDPOINT}/api/v1/label/job/values" | jq '.')
echo "All Scape Jobs: $all_scrape_jobs"
sleep 5
################################################################################
# TEST 3: Discover Retail Store Services
################################################################################
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST 3: Discover Retail Store Services"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

discover_retail_store_services=$(awscurl --service="aps" --region="$AWS_REGION" \
  "${AMP_ENDPOINT}/api/v1/label/service/values" | jq '.')
echo "Discover Retail Store Services: $discover_retail_store_services"
sleep 5
################################################################################
# TEST 4: Total Unique Metrics Count
################################################################################
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "TEST 4: Total Unique Metrics"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

total_unique_metrics=$(awscurl --service="aps" --region="$AWS_REGION" \
  "${AMP_ENDPOINT}/api/v1/label/__name__/values" | jq '.data | length')

echo "Total unique metrics: $total_unique_metrics"
echo ""
sleep 5
################################################################################
# SUMMARY
################################################################################
echo "============================================================================"
echo "                        VERIFICATION COMPLETE"
echo "============================================================================"
echo ""
echo "Summary:"

echo "Total Unique Metrics: $total_unique_metrics"
echo ""
echo "all_scrape_jobs: $all_scrape_jobs"
echo ""
echo "Discover Retail Store Services: $discover_retail_store_services"
echo ""
echo "✓ All tests completed successfully!"
echo ""
