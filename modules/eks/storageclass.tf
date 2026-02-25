resource "kubernetes_storage_class_v1" "gp3" {
  metadata {
    name = var.storage_class_name
  }

  storage_provisioner = "ebs.csi.aws.com"

  parameters = {
    type = var.storage_type
  }

  reclaim_policy = "Delete"
}