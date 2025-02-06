variable "region" {}
variable "cluster_name" {}
variable "node_role_arn" {}
variable "subnet_ids" { type = list(string) }
variable "instance_types" { type = list(string) }
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}

