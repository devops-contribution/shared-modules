terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.customer}-terraform-vpc"
  }
}

# Data source to get all Availability Zones in the region
data "aws_availability_zones" "available_zones" {}

# Private Subnet in AZ1
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.private_subnet_az1_cidr 
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.customer}-private-subnet-az1"
  }
}

# Private Subnet in AZ2
resource "aws_subnet" "private_subnet_az2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.private_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.customer}-private-subnet-az2"
  }
}

# Public Subnet for NAT Gateway
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_nat_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true  # Public for NAT

  tags = {
    Name = "${var.customer}-public-subnet-for-nat"
  }
}

# Internet Gateway (needed for NAT Gateway)
resource "aws_internet_gateway" "eks_internet_gateway" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.customer}-eks-igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# NAT Gateway in Public Subnet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "${var.customer}-nat-gateway"
  }
}

# Private Route Table (Uses NAT Gateway)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.customer}-private-route-table"
  }
}

# Associate Private Subnet in AZ1 with Private Route Table
resource "aws_route_table_association" "private_subnet_az1_association" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}

# Associate Private Subnet in AZ2 with Private Route Table
resource "aws_route_table_association" "private_subnet_az2_association" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_route_table.id
}

# Public Route Table for NAT Gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_internet_gateway.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Public Subnet with Public Route Table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
