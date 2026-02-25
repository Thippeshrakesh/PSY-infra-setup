resource "aws_eks_cluster" "this" {
  name     = "${var.project_name}-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_public_access  = var.cluster_endpoint_public_access
    endpoint_private_access = var.cluster_endpoint_private_access
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}