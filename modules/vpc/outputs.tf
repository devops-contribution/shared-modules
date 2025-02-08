output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

output "internet_gateway" {
  value = aws_internet_gateway.eks_internet_gateway.id
}
