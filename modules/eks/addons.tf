resource "aws_eks_addon" "addons" {
  for_each = toset(var.addon_names)

  cluster_name = aws_eks_cluster.this.name
  addon_name   = each.value
}