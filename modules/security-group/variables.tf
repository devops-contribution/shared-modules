variable "vpc_id" {
  type = string
}

variable "ssh_access" {
  type = list(string)
}

variable "http_access" {
  type = list(string)
}
