aws_region = "us-east-1"
environment_name = "staging"
cluster_name = "eks-cluster"
cluster_service_ipv4_cidr = "172.21.0.0/16"
cluster_version = "1.33"

cluster_endpoint_private_access = true
cluster_endpoint_public_access = false
cluster_endpoint_public_access_cidrs = ["10.0.0.0/8"]

node_instance_types = ["t3.large"]
node_capacity_type  = "SPOT"
node_disk_size      = 30

business_division = "retail"
