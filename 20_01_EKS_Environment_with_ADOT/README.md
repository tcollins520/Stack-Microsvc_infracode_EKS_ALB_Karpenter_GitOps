# 20_01 AWS Distro for Open Telemetry (ADOT) EKS Add-On


## Step-01: Introduction


### Pre-requisite Checks
1. Ensure EKS Cluster is not yet created.
2. Anything created before this demo, destroy them.

### Important Pre-requisite - Needed for Amazon Managed Grafana
1. Enable AWS IAM Identity Center

## Step-02: Review OPEN TELEMETRY Terraform Project
- [05_OPENTELEMTRY_terraform-manifests](./01_EKS_Cluster_Environment/05_OPENTELEMTRY_terraform-manifests/)

```
├── 01_EKS_Cluster_Environment
│   ├── 05_OPENTELEMTRY_terraform-manifests
│   │   ├── c1_versions.tf
│   │   ├── c2_variables.tf
│   │   ├── c3_01_vpc_remote_state.tf
│   │   ├── c3_02_eks_remote_state.tf
│   │   ├── c4_datasources_and_locals.tf
│   │   ├── c5_helm_and_kubernetes_providers.tf
│   │   ├── c6_01_adot_collector_iam_role.tf
│   │   ├── c6_02_adot_collector_iam_policy.tf
│   │   ├── c6_03_adot_pod_identity_association.tf
│   │   ├── c6_04_eks_addon_certmanager.tf
│   │   ├── c6_05_eks_addon_adot.tf
│   │   ├── c6_06_eks_addon_prometheus_node_exporter.tf
│   │   ├── c6_07_eks_addon_kube_state_metrics.tf
│   │   ├── c6_09_adot_k8s_cluster_role_and_rolebinding.tf
│   │   ├── c7_amp_prometheus_workspace.tf
│   │   ├── c8_01_amg_grafana_iam_policy.tf
│   │   ├── c8_02_amg_grafana_iam_role.tf
│   │   ├── c8_03_amg_grafana.tf
│   │   └── terraform.tfvars
```

## Step-03: Review the complete Folder Structure for EKS Cluster
```
01_EKS_Cluster_Environment/
├── 01_VPC_terraform-manifests
│   ├── c1-versions.tf
│   ├── c2-variables.tf
│   ├── c3-vpc.tf
│   ├── c4-outputs.tf
│   ├── modules
│   │   └── vpc
│   │       ├── datasources-and-locals.tf
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       ├── README.md
│   │       └── variables.tf
│   └── terraform.tfvars
├── 02_EKS_terraform-manifests_with_addons
│   ├── c1_versions.tf
│   ├── c10_eks_outputs.tf
│   ├── c11-podidentityagent-eksaddon.tf
│   ├── c12-helm-and-kubernetes-providers.tf
│   ├── c13-podidentity-assumerole.tf
│   ├── c14-01-lbc-iam-policy-datasources.tf
│   ├── c14-02-lbc-iam-policy-and-role.tf
│   ├── c14-03-lbc-eks-pod-identity-association.tf
│   ├── c14-04-lbc-helm-install.tf
│   ├── c15-01-ebscsi-iam-policy-and-role.tf
│   ├── c15-02-ebscsi-eks-pod-identity-association.tf
│   ├── c15-03-ebscsi-eksaddon.tf
│   ├── c16-01-secretstorecsi-helm-install.tf
│   ├── c16-02-secretstorecsi-ascp-helm-install.tf
│   ├── c17-01-externaldns-iam-policy-and-role.tf
│   ├── c17-02-externaldns-pod-identity-association.tf
│   ├── c17-03-externaldns-eksaddon.tf
│   ├── c18_eksaddon_metrics_server.tf
│   ├── c2_variables.tf
│   ├── c3_remote-state.tf
│   ├── c4_datasources_and_locals.tf
│   ├── c5_eks_tags.tf
│   ├── c6_eks_cluster_iamrole.tf
│   ├── c7_eks_cluster.tf
│   ├── c8_eks_nodegroup_iamrole.tf
│   ├── c9_eks_nodegroup_private.tf
│   ├── env
│   │   ├── dev.tfvars
│   │   ├── prod.tfvars
│   │   └── staging.tfvars
│   └── terraform.tfvars
├── 03_KARPENTER_terraform-manifests
│   ├── c1_versions.tf
│   ├── c2_variables.tf
│   ├── c3_01_vpc_remote_state.tf
│   ├── c3_02_eks_remote_state.tf
│   ├── c4_datasources_and_locals.tf
│   ├── c5_helm_and_kubernetes_providers.tf
│   ├── c6_01_karpenter_controller_iam_role.tf
│   ├── c6_02_karpenter_controller_iam_policy.tf
│   ├── c6_03_karpenter_pod_identity_association.tf
│   ├── c6_04_karpenter_node_iam_role.tf
│   ├── c6_05_karpenter_access_entry.tf
│   ├── c6_06_karpenter_helm_install.tf
│   ├── c6_07_karpenter_sqs_queue.tf
│   ├── c6_08_karpenter_eventbridge_rules.tf
│   └── terraform.tfvars
├── 04_KARPENTER_k8s-manifests
│   ├── 01_ec2nodeclass.yaml
│   ├── 02_nodepool_ondemand.yaml
│   └── 03_nodepool_spot.yaml
├── 05_OPENTELEMTRY_terraform-manifests
│   ├── c1_versions.tf
│   ├── c2_variables.tf
│   ├── c3_01_vpc_remote_state.tf
│   ├── c3_02_eks_remote_state.tf
│   ├── c4_datasources_and_locals.tf
│   ├── c5_helm_and_kubernetes_providers.tf
│   ├── c6_01_adot_collector_iam_role.tf
│   ├── c6_02_adot_collector_iam_policy.tf
│   ├── c6_03_adot_pod_identity_association.tf
│   ├── c6_04_eks_addon_certmanager.tf
│   ├── c6_05_eks_addon_adot.tf
│   ├── c6_06_eks_addon_prometheus_node_exporter.tf
│   ├── c6_07_eks_addon_kube_state_metrics.tf
│   ├── c6_09_adot_k8s_cluster_role_and_rolebinding.tf
│   ├── c7_amp_prometheus_workspace.tf
│   ├── c8_01_amg_grafana_iam_policy.tf
│   ├── c8_02_amg_grafana_iam_role.tf
│   ├── c8_03_amg_grafana.tf
│   └── terraform.tfvars
├── create-cluster-with-karpenter-and-opentelemetry.sh
└── destroy-cluster-with-karpenter-and-opentelemetry.sh
```

## Step-04: Create EKS Cluster with all Addons 
```bash
# Update your S3 Bucket for Terraform State Storage in all Terraform Projects
c1-versions.tf
cX_remote-state.tf
cX_XX_vpc_remote_state.tf
cX_XX_eks_remote_state.tf

# Change Directory
cd devops-real-world-project-implementation-on-aws/20_Observability_OpenTelemetry/20_01_EKS_Environment_with_ADOT/01_EKS_Cluster_Environment

# Create EKS Cluster, Karpenter and Open Telemetry
./create-cluster-with-karpenter-and-opentelemetry.sh
# OR
# GO TO each terraform project and run
terraform init
terraform validate
terraform plan
terraform apply -auto-approve

# List Kubernetes Nodes
kubectl get nodes

# List all add-ons for a cluster
aws eks list-addons --cluster-name retail-dev-eksdemo1
```

