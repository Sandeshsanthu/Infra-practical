module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 20.0"

  cluster_name = module.eks.cluster_name

  enable_v1_permissions = true

  # Attach Pod Identity access to the Karpenter Controller
  enable_pod_identity             = true
  create_pod_identity_association = true

  # Queue configuration for Spot Interruption and Instance State Events
  enable_spot_termination = true
  queue_name              = "${var.cluster_name}-karpenter-interruption"

  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

# Deploy Karpenter via Helm
resource "helm_release" "karpenter" {
  namespace        = "kube-system"
  name             = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = "1.0.1"
  create_namespace = false

  values = [
    yamlencode({
      settings = {
        clusterName       = module.eks.cluster_name
        clusterEndpoint   = module.eks.cluster_endpoint
        interruptionQueue = module.karpenter.queue_name
      }
      serviceAccount = {
        create = true
        name   = "karpenter"
        annotations = {
          # Blank if using Pod Identities exclusively, handled by the module mapping
        }
      }
      nodeSelector = {
        "node-role.kubernetes.io/system" = "true"
      }
      # Schedule controller pods exclusively onto your system bootstrap nodes
      tolerations = []
    })
  ]
}
