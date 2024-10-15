# # Create the IAM OIDC provider
# resource "aws_iam_openid_connect_provider" "eks_oidc" {
#   url = data.aws_eks_cluster.existing.identity[0].oidc[0].issuer

#   client_id_list = [
#     "sts.amazonaws.com" # or other clients if needed
#   ]

#   thumbprint_list = [
#     data.aws_eks_cluster.existing.identity[0].oidc[0].thumbprint
#   ]
# }