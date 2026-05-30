aws_region = "us-east-1"
environment_name = "prod"
cluster_name = "eks-cluster"
cluster_service_ipv4_cidr = "172.22.0.0/16"
cluster_version = "1.33"

cluster_endpoint_private_access = true
cluster_endpoint_public_access = false
cluster_endpoint_public_access_cidrs = ["10.0.0.0/8"]

node_instance_types = ["m5.large"]
node_capacity_type  = "ON_DEMAND"
node_disk_size      = 50

business_division = "retail"
