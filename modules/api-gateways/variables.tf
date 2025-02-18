variable "alb_dns" {
  type = string
}

variable "region" {
  type = string
}

variable "customer" {
  type = string
}

variable "vpc_link_security_group_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}
