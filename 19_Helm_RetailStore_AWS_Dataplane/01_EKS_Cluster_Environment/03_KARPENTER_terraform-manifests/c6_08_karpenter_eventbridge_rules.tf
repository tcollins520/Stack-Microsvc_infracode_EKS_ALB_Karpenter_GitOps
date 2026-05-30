# ============================================================================
# File: c6_08_karpenter_eventbridge_rules.tf
# Purpose:
#   EventBridge rules that detect EC2 Spot interruptions, AWS Health events,
#   EC2 rebalance recommendations, and EC2 instance state changes, and send
#   those events to the Karpenter SQS interruption queue.
#
#   This enables Karpenter to gracefully cordon, drain, and replace Spot nodes.
#
# Requirements:
#   - SQS queue must exist (aws_sqs_queue.karpenter_interruption)
#   - IAM policy for Karpenter controller must include sqs:* permissions
#
# Reference:
#   AWS Official Karpenter template:
#   https://github.com/aws/karpenter/
# ============================================================================

locals {
  short_cluster = substr(local.cluster_name, 0, 20)
}

# ----------------------------------------------------------------------------
# AWS Health Events → SQS
# ----------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "karpenter_health_event" {
  name        = "${local.short_cluster}-k-health"
  description = "AWS Health Event → Karpenter Interruption Queue"

  event_pattern = jsonencode({
    source       = ["aws.health"]
    "detail-type" = ["AWS Health Event"]
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "karpenter_health_target" {
  rule      = aws_cloudwatch_event_rule.karpenter_health_event.name
  target_id = "KarpenterHealthTarget"
  arn       = aws_sqs_queue.karpenter_interruption.arn
}

# ----------------------------------------------------------------------------
# EC2 Spot Interruption Warning → SQS
# ----------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "karpenter_spot_interrupt" {
  name        = "${local.short_cluster}-k-spot"
  description = "EC2 Spot Interruption Warning → Karpenter SQS Queue"

  event_pattern = jsonencode({
    source       = ["aws.ec2"]
    "detail-type" = ["EC2 Spot Instance Interruption Warning"]
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "karpenter_spot_target" {
  rule      = aws_cloudwatch_event_rule.karpenter_spot_interrupt.name
  target_id = "KarpenterSpotTarget"
  arn       = aws_sqs_queue.karpenter_interruption.arn
}

# ----------------------------------------------------------------------------
# EC2 Instance Rebalance Recommendation → SQS
# ----------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "karpenter_rebalance" {
  name        = "${local.short_cluster}-k-rebal"
  description = "EC2 Instance Rebalance Recommendation → Karpenter SQS Queue"

  event_pattern = jsonencode({
    source       = ["aws.ec2"]
    "detail-type" = ["EC2 Instance Rebalance Recommendation"]
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "karpenter_rebalance_target" {
  rule      = aws_cloudwatch_event_rule.karpenter_rebalance.name
  target_id = "KarpenterRebalanceTarget"
  arn       = aws_sqs_queue.karpenter_interruption.arn
}

# ----------------------------------------------------------------------------
# EC2 Instance State-change Notification → SQS
# ----------------------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "karpenter_instance_state" {
  name        = "${local.short_cluster}-k-state"
  description = "EC2 Instance State Change Notification → Karpenter SQS Queue"

  event_pattern = jsonencode({
    source       = ["aws.ec2"]
    "detail-type" = ["EC2 Instance State-change Notification"]
  })

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "karpenter_instance_state_target" {
  rule      = aws_cloudwatch_event_rule.karpenter_instance_state.name
  target_id = "KarpenterStateTarget"
  arn       = aws_sqs_queue.karpenter_interruption.arn
}
