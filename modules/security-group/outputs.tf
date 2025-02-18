output "eks_security_group_id" {
  value = aws_security_group.eks_security_group.id
}


output "vpc_link_sg_id" {
  value = aws_security_group.allow_all_traffic.id
}
