module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "prod-zero-trust-cluster"
  cluster_version = "1.30" # Latest stable K8s version

  # 1. Place the cluster inside the Private Prod Spoke
  vpc_id                   = module.prod_spoke_vpc.vpc_id
  subnet_ids               = module.prod_spoke_vpc.private_subnets
  control_plane_subnet_ids = module.prod_spoke_vpc.private_subnets

  # 2. Allow your local computer to talk to the K8s API to run kubectl commands
  cluster_endpoint_public_access = true

  # 3. Create the Worker Nodes (The servers that run your Pods)
  eks_managed_node_groups = {
    worker_group = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.medium"] # Minimum size required to run K8s reliably
    }
  }

  tags = {
    Environment = "Production"
    Project     = "Zero-Trust-K8s"
  }
}

# 4. Output the command needed to connect to the cluster later
output "configure_kubectl" {
  description = "Run this command to configure kubectl"
  value       = "aws eks update-kubeconfig --region us-east-1 --name prod-zero-trust-cluster"
}