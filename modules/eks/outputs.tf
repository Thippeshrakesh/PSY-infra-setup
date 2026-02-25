output "cluster_id" {
  value = aws_eks_cluster.this.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "node_security_group_id" {
  value = aws_security_group.eks_cluster_sg.id
}