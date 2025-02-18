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
  name   = "eks-private-cluster-sg"
  vpc_id = var.vpc_id

  # Allow all nodes to communicate within the cluster
  ingress {
    description = "Allow all traffic between EKS nodes"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow Kubernetes API Server Access within VPC only
  ingress {
    description = "Allow EKS API Server Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow communication between worker nodes and control plane
  ingress {
    description = "Allow Kubernetes control plane to worker nodes"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow CoreDNS and Kubelet communication
  ingress {
    description = "Allow CoreDNS and Kubelet communication"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow outbound internet access (if needed for updates)
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
