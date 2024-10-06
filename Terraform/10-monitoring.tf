# Install Prometheus and Grafana using Helm
# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
# }

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  }
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

# Create a Kubernetes namespace in the EKS cluster
resource "kubernetes_namespace" "monitoring2" {
  metadata {
    name = "monitoring2"
  }
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
}


# resource "helm_release" "grafana" {
#   name             = "grafana"
#   repository       = "https://grafana.github.io/helm-charts"
#   chart            = "grafana"
#   namespace        = "monitoring"
#   create_namespace = true
# }
