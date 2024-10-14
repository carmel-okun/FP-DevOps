# IAM Role for EKS
resource "aws_iam_role" "eks_clsuter_role" {
  name = "yoram_carmel_eks_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.eks_clsuter_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_eks_cluster" "eks" {
  name     = "yoram-carmel-eks-cluster"
  version  = "1.30"
  role_arn = aws_iam_role.eks_clsuter_role.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    subnet_ids = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id,
      aws_subnet.private_a1.id,
      aws_subnet.private_a2.id,
      aws_subnet.private_b.id
    ]
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  tags = {
    Project = "TeamD"
  }

  depends_on = [aws_iam_role_policy_attachment.eks]
}