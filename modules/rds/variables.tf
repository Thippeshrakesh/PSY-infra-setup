variable "project_name" { type = string }
variable "tenants" { type = list(string) }

variable "vpc_id" { type = string }
variable "vpc_cidr" { type = string }
variable "postgres_subnet_ids" { type = list(string) }

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

variable "primary_az" { type = string }
variable "common_tags" { type = map(string) }