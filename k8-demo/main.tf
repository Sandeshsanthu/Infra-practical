resource "aws_vpc" "eks_vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true

  
}

resource "aws_subnet" "eks_subnets" {
  count             = 2
  vpc_id = aws_vpc.eks_vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = "us-east-1${element(["a", "b"], count.index)}"
}

resource "aws_eks_cluster" "prod" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_subnets[*].id
  }
}

resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "network-ingress"
    labels = {
      environment = "production"
      tier        = "routing"
    }
  }
}
resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://github.io"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.ingress.metadata[0].name
  timeout    = 600
  wait       = true # Forces TF to wait until the pods are running

  # Production-grade Helm values override
  values = [
    yamlencode({
      controller = {
        replicaCount = 2
        minAvailable = 1
        resources = {
          limits = { cpu = "500m", memory = "512Mi" }
          requests = { cpu = "200m", memory = "256Mi" }
        }
        service = {
          annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
          }
        }
      }
    })
  ]
}
