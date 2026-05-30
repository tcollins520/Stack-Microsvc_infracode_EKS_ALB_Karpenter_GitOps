data "aws_iam_policy_document" "karpenter_controller" {

  # ---------------------------------------------------------------------------
  # AllowScopedEC2InstanceAccessActions
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowScopedEC2InstanceAccessActions"
    effect = "Allow"

    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet",
    ]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.region}::image/*",
      "arn:aws:ec2:${data.aws_region.current.region}::snapshot/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:security-group/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:subnet/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:capacity-reservation/*",
    ]
  }

  # ---------------------------------------------------------------------------
  # AllowScopedEC2LaunchTemplateAccessActions
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowScopedEC2LaunchTemplateAccessActions"
    effect = "Allow"

    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet",
    ]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.region}:*:launch-template/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${local.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.sh/nodepool"
      values   = ["*"]
    }
  }

  # ---------------------------------------------------------------------------
  # AllowScopedEC2InstanceActionsWithTags
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowScopedEC2InstanceActionsWithTags"
    effect = "Allow"

    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet",
      "ec2:CreateLaunchTemplate",
    ]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.region}:*:fleet/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:instance/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:volume/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:network-interface/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:launch-template/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:spot-instances-request/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:capacity-reservation/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${local.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = [local.cluster_name]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.sh/nodepool"
      values   = ["*"]
    }
  }

  # ---------------------------------------------------------------------------
  # AllowScopedResourceCreationTagging
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowScopedResourceCreationTagging"
    effect = "Allow"

    actions = [
      "ec2:CreateTags",
    ]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.region}:*:fleet/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:instance/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:volume/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:network-interface/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:launch-template/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:spot-instances-request/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${local.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = [local.cluster_name]
    }

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = [
        "RunInstances",
        "CreateFleet",
        "CreateLaunchTemplate",
      ]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.sh/nodepool"
      values   = ["*"]
    }
  }

  # ---------------------------------------------------------------------------
  # AllowScopedResourceTagging
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowScopedResourceTagging"
    effect = "Allow"

    actions = [
      "ec2:CreateTags",
    ]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.region}:*:instance/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${local.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.sh/nodepool"
      values   = ["*"]
    }

    condition {
      test     = "StringEqualsIfExists"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = [local.cluster_name]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "aws:TagKeys"
      values = [
        "eks:eks-cluster-name",
        "karpenter.sh/nodeclaim",
        "Name",
      ]
    }
  }

  # ---------------------------------------------------------------------------
  # AllowScopedDeletion
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowScopedDeletion"
    effect = "Allow"

    actions = [
      "ec2:TerminateInstances",
      "ec2:DeleteLaunchTemplate",
    ]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.region}:*:instance/*",
      "arn:aws:ec2:${data.aws_region.current.region}:*:launch-template/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${local.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.sh/nodepool"
      values   = ["*"]
    }
  }

  # ---------------------------------------------------------------------------
  # AllowRegionalReadActions
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowRegionalReadActions"
    effect = "Allow"

    actions = [
      "ec2:DescribeCapacityReservations",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [data.aws_region.current.region]
    }
  }

  # ---------------------------------------------------------------------------
  # AllowSSMReadActions
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowSSMReadActions"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.region}::parameter/aws/service/*",
    ]
  }

  # ---------------------------------------------------------------------------
  # AllowPricingReadActions
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowPricingReadActions"
    effect = "Allow"

    actions = [
      "pricing:GetProducts",
    ]

    resources = ["*"]
  }

  # ---------------------------------------------------------------------------
  # AllowInterruptionQueueActions
  # (assumes aws_sqs_queue.karpenter_interruption exists)
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowInterruptionQueueActions"
    effect = "Allow"

    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes", 
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
    ]

    resources = [
      aws_sqs_queue.karpenter_interruption.arn,
    ]
  }

  # ---------------------------------------------------------------------------
  # AllowPassingInstanceRole
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowPassingInstanceRole"
    effect = "Allow"

    actions = [
      "iam:PassRole",
    ]

    resources = [
      aws_iam_role.karpenter_node.arn,
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values = [
        "ec2.amazonaws.com",
        "ec2.amazonaws.com.cn",
      ]
    }
  }

  # ---------------------------------------------------------------------------
  # AllowScopedInstanceProfileCreationActions
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowScopedInstanceProfileCreationActions"
    effect = "Allow"

    actions = [
      "iam:CreateInstanceProfile",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${local.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = [local.cluster_name]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = [data.aws_region.current.region]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"
      values   = ["*"]
    }
  }

  # ---------------------------------------------------------------------------
  # AllowScopedInstanceProfileTagActions
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowScopedInstanceProfileTagActions"
    effect = "Allow"

    actions = [
      "iam:TagInstanceProfile",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${local.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = [data.aws_region.current.region]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${local.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/eks:eks-cluster-name"
      values   = [local.cluster_name]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = [data.aws_region.current.region]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass"
      values   = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"
      values   = ["*"]
    }
  }

  # ---------------------------------------------------------------------------
  # AllowScopedInstanceProfileActions
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowScopedInstanceProfileActions"
    effect = "Allow"

    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:DeleteInstanceProfile",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${local.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = [data.aws_region.current.region]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass"
      values   = ["*"]
    }
  }

  # ---------------------------------------------------------------------------
  # AllowInstanceProfileReadActions
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowInstanceProfileReadActions"
    effect = "Allow"

    actions = [
      "iam:GetInstanceProfile",
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/*",
    ]
  }

  # ---------------------------------------------------------------------------
  # AllowUnscopedInstanceProfileListAction
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowUnscopedInstanceProfileListAction"
    effect = "Allow"

    actions = [
      "iam:ListInstanceProfiles",
    ]

    resources = ["*"]
  }

  # ---------------------------------------------------------------------------
  # AllowAPIServerEndpointDiscovery
  # ---------------------------------------------------------------------------
  statement {
    sid    = "AllowAPIServerEndpointDiscovery"
    effect = "Allow"

    actions = [
      "eks:DescribeCluster",
    ]

    resources = [
      "arn:aws:eks:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:cluster/${local.cluster_name}",
    ]
  }
}

resource "aws_iam_policy" "karpenter_controller" {
  name        = "${local.name}-karpenter-controller-policy"
  description = "Karpenter controller IAM policy (AWS official)"
  policy      = data.aws_iam_policy_document.karpenter_controller.json
  tags        = var.tags
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_attach" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.karpenter_controller.arn
}
