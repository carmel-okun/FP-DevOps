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

# EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "yoram-carmel-eks-cluster"
  cluster_version = "1.30"
  subnet_ids      = [aws_subnet.private_a1.id, aws_subnet.private_a2.id, aws_subnet.private_b.id]
  vpc_id          = aws_vpc.main.id

  depends_on = [aws_iam_role_policy_attachment.eks]
}
