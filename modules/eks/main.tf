terraform {
  required_version = ">= 1.0" 
}

resource "aws_eks_cluster" "eks" {
  name     = "terraform-aws-eks"
  role_arn = var.master_arn

  vpc_config {
    subnet_ids = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  }
}

#data "aws_availability_zones" "available_zones" {}

resource "aws_key_pair" "eks_key" {
  key_name   = "eks-key-pair"
  public_key = var.public_key
}

resource "aws_eks_node_group" "node-grp" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "Worker-Node-Group"
  node_role_arn   = var.worker_arn
  subnet_ids      = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  capacity_type   = "ON_DEMAND"
  disk_size       = 20
  instance_types  = [var.instance_size]

  # Below block is optional.
  remote_access {
    ec2_ssh_key               = aws_key_pair.eks_key.key_name
    source_security_group_ids = [var.eks_security_group_id]
  }

  labels = {
    env = "dev"
  }

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}
