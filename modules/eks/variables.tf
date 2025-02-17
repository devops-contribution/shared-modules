variable "private_subnet_az1_id" {
  type = string
}

variable "private_subnet_az2_id" {
  type = string
}

variable "eks_security_group_id" {
  type = string
}

variable "master_arn" {
  type = string
}

variable "worker_arn" {
  type = string
}

variable "instance_size" {
  type = string
}

variable "public_key" {
  type = string
}

variable "customer" {
  type = string
}
