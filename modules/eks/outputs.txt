output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks.arn
}


output "cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

