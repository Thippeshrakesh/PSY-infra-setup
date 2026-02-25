data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

resource "kubernetes_storage_class_v1" "default" {
  metadata {
    name = var.storage_class_name
  }

  storage_provisioner = "ebs.csi.aws.com"

  parameters = {
    type = var.storage_type
  }
}