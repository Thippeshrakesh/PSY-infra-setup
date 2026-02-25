variable "project_name" { type = string }

variable "vpc_id" { type = string }

variable "private_subnet_ids" { type = list(string) }

variable "public_subnet_ids" { type = list(string) }

variable "cluster_version" { type = string }

variable "cluster_endpoint_public_access" { type = bool }

variable "cluster_endpoint_private_access" { type = bool }

variable "node_instance_types" { type = list(string) }

variable "desired_size" { type = number }

variable "min_size" { type = number }

variable "max_size" { type = number }

variable "addon_names" {
  type = list(string)
}

variable "storage_class_name" { type = string }

variable "storage_type" { type = string }