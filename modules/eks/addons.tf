resource "aws_eks_addon" "addons" {
  for_each = toset(var.addon_names)

  cluster_name = aws_eks_cluster.this.name
  addon_name   = each.value

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  tags = var.common_tags
}