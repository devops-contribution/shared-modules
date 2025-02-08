resource "aws_eks_cluster" "eks" {
  name     = "AWS-EKS"
  role_arn = var.master_arn

  vpc_config {
    subnet_ids = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  }
}

data "aws_availability_zones" "available_zones" {}

resource "aws_eks_node_group" "node-grp" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "Worker-Node-Group"
  node_role_arn   = var.worker_arn
  subnet_ids      = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  capacity_type   = "ON_DEMAND"
  disk_size       = 20
  instance_types  = [var.instance_size]

  remote_access {
    ec2_ssh_key               = var.key_name
    source_security_group_ids = [var.eks_security_group_id]
  }

  labels = {
    env = "sandbox"
  }

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}
