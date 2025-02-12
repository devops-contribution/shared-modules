terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Allows any version 5.x.x
    }
  }
}


resource "aws_security_group" "eks_security_group" {
  name   = "SH security group"
  vpc_id = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_access
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.http_access
  }

  ingress {
    description = "HTTPS port"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.http_access
  }

  egress {
    description = "outbound access"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
