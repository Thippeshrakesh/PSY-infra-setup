module "vpc" {
  source = "../../modules/vpc"

  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs      = var.db_subnet_cidrs
  common_tags          = var.common_tags
}

module "rds" {
  source = "../../modules/rds"

  project_name = var.project_name
  tenants      = var.tenants

  vpc_id              = module.vpc.vpc_id
  vpc_cidr            = var.vpc_cidr
  postgres_subnet_ids = module.vpc.db_subnet_ids

  primary_az = var.primary_az

  postgres_engine                  = var.postgres_engine
  postgres_engine_version          = var.postgres_engine_version
  postgres_instance_class          = var.postgres_instance_class
  postgres_allocated_storage       = var.postgres_allocated_storage
  postgres_storage_type            = var.postgres_storage_type
  postgres_multi_az                = var.postgres_multi_az
  postgres_publicly_accessible     = var.postgres_publicly_accessible
  postgres_backup_retention_period = var.postgres_backup_retention_period
  postgres_deletion_protection     = var.postgres_deletion_protection
  postgres_storage_encrypted       = var.postgres_storage_encrypted

  common_tags = var.common_tags
}






# module "eks" {
#   source = "../../modules/eks"

#   project_name       = var.project_name
#   vpc_id             = module.vpc.vpc_id
#   private_subnet_ids = module.vpc.private_subnet_ids
#   public_subnet_ids  = module.vpc.public_subnet_ids

#   cluster_version                  = var.cluster_version
#   cluster_endpoint_public_access   = var.cluster_endpoint_public_access
#   cluster_endpoint_private_access  = var.cluster_endpoint_private_access

#   node_instance_types = var.node_instance_types
#   desired_size        = var.desired_size
#   min_size            = var.min_size
#   max_size            = var.max_size

#   addon_names         = var.addon_names

#   storage_class_name  = var.storage_class_name
#   storage_type        = var.storage_type
# }





















# module "rds" {
#   source = "../../modules/rds"

#   project_name                      = var.project_name
#   tenants                           = var.tenants
#   vpc_id                            = module.vpc.vpc_id
#   postgres_subnet_ids               = module.vpc.db_subnet_ids
#   allowed_security_group_ids        = []

#   postgres_engine                   = "postgres"
#   postgres_engine_version           = "15.5"
#   postgres_instance_class           = "db.m6g.large"
#   postgres_allocated_storage        = 20

#   postgres_publicly_accessible      = false
#   postgres_backup_retention_period  = 35
#   postgres_deletion_protection      = true
#   postgres_storage_encrypted        = true

#   primary_az                        = "ap-south-2a"
#   postgres_kms_key_arn              = null
#   rds_monitoring_role_arn           = null
# }

