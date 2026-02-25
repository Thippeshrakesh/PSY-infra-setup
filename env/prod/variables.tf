variable "vpc_name" { type = string }
variable "vpc_cidr" { type = string }
variable "azs" { type = list(string) }

variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }
variable "db_subnet_cidrs" { type = list(string) }

variable "project_name" { type = string }
variable "tenants" { type = list(string) }

variable "primary_az" { type = string }

variable "postgres_engine" { type = string }
variable "postgres_engine_version" { type = string }
variable "postgres_instance_class" { type = string }
variable "postgres_allocated_storage" { type = number }
variable "postgres_storage_type" { type = string }
variable "postgres_multi_az" { type = bool }
variable "postgres_publicly_accessible" { type = bool }
variable "postgres_backup_retention_period" { type = number }
variable "postgres_deletion_protection" { type = bool }
variable "postgres_storage_encrypted" { type = bool }

variable "common_tags" { type = map(string) }



#################################################
# EKS VARIABLES
#################################################

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "cluster_endpoint_public_access" {
  type = bool
}

variable "cluster_endpoint_private_access" {
  type = bool
}

variable "node_instance_types" {
  type = list(string)
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "addon_names" {
  type = list(string)
}

variable "storage_class_name" {
  type = string
}

variable "storage_type" {
  type = string
}