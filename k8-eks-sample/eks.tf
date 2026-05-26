module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = "API_AND_CONFIG_MAP"

  # Core System Add-ons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_pod_identity.iam_role_arn
    }
  }

  # Bootstrap Nodes for Core System Controllers
  eks_managed_node_groups = {
    system_bootstrap = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1

      labels = {
        "node-role.kubernetes.io/system" = "true"
      }

      # 🟢 Fixed: Taints block entirely removed to allow CoreDNS & CSI pods to schedule
      taints = {}
    }
  }

  # Node security group configuration for Karpenter dynamic instances
  node_security_group_tags = {
    "karpenter.sh/discovery" = var.cluster_name
  }
}
