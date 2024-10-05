# IAM Role for EKS
resource "aws_iam_role" "eks_role" {
  name = "carmel_yoram_eks_role"

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

# EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "carmel-yoram-eks-cluster"
  cluster_version = "1.21"
  subnets         = [aws_subnet.private_a1.id, aws_subnet.private_a2.id,  aws_subnet.private_b.id]
  vpc_id          = aws_vpc.main.id

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t2.medium"
    }
  }
  manage_aws_auth = true
}
