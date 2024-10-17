# Create a Kubernetes namespace in the EKS cluster
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}