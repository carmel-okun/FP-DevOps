# IAM Role for EKS
resource "aws_iam_role" "eks_node_role" {
	name = "yoram_carmel_eks_node_role"

	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [{
			Action = "sts:AssumeRole"
			Effect = "Allow"
			Principal = {
				Service = "ec2.amazonaws.com"
			}
		}]
	})
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policy" {
	role       = aws_iam_role.eks_node_role.name
	policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
	role       = aws_iam_role.eks_node_role.name
	policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ecr_policy" {
	role       = aws_iam_role.eks_node_role.name
	policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_node_group" "app" {
	cluster_name = aws_eks_cluster.eks.name
	version = "1.30"
	node_group_name = "app"
	node_role_arn = aws_iam_role.eks_node_role.arn

	subnet_ids = [
		aws_subnet.private_a1.id,
		aws_subnet.private_b.id
	]

	instance_types = ["t2.medium"]

	scaling_config {
		min_size = 1
		desired_size = 1
		max_size = 2
	}

	update_config {
		max_unavailable = 1
	}

	labels = {
		role = "app"
	}

	depends_on = [
		aws_iam_role_policy_attachment.eks_node_role_policy,
		aws_iam_role_policy_attachment.eks_cni_policy,
		aws_iam_role_policy_attachment.eks_ecr_policy
	]

	# Allow external changes without Terraform plan difference
	lifecycle {
		ignore_changes = [scaling_config[0].desired_size]
	}
}