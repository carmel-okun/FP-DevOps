# Create a Kubernetes namespace in the EKS cluster
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }

  depends_on = [aws_eks_cluster.eks]
}