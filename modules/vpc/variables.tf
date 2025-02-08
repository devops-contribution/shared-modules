variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  #default = "10.0.0.0/16"
}

variable "public_subnet_az1_cidr" {
  type    = string
  #default = "10.0.1.0/24"
}

variable "public_subnet_az2_cidr" {
  type    = string
  #default = "10.0.2.0/24"
}
