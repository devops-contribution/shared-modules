variable "vpc_id" {
  type = string
}

variable "env" {
  type = string
}

variable "type" {
  type = string
}

variable "project_name" {
  type = string
}

variable "ssh_access" {
  type = list(string)
}

variable "http_access" {
  type = list(string)
}
