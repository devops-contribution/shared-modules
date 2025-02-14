terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Allows any version 5.x.x
    }
  }
}

# S3 bucket for Vault storage
resource "aws_s3_bucket" "vault_storage" {
  bucket = var.bucket_name
  force_destroy = true
}

# IAM policy for Vault to access the S3 bucket
resource "aws_iam_policy" "vault_s3_policy" {
  name        = "VaultS3Policy"
  description = "Allows Vault to access the S3 backend"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::vault-backend-bucket",
        "arn:aws:s3:::vault-backend-bucket/*"
      ]
    }
  ]
}
EOF
}

# IAM role to be assumed by Vault
resource "aws_iam_role" "vault_role" {
  name = "role-for-vault"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "vault_policy_attach" {
  role       = aws_iam_role.vault_role.name
  policy_arn = aws_iam_policy.vault_s3_policy.arn
}

# Security Group for Vault
resource "aws_security_group" "vault_sg" {
  name        = "vault-security-group"
  description = "Allow Vault traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "latest_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_iam_instance_profile" "vault_instance_profile" {
  name = "vault-instance-profile"
  role = aws_iam_role.vault_role.name
}

# EC2 instance for Vault
resource "aws_instance" "vault" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t3.medium"
  iam_instance_profile = aws_iam_instance_profile.vault_instance_profile.name
  vpc_security_group_ids = [aws_security_group.vault_sg.id]
  subnet_id       = var.subnet_id

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y unzip jq
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    echo "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install -y vault
    echo "storage "s3" {
      bucket = \"vault-backend-bucket\"
      region = \"us-east-1\"
    }" > /etc/vault.hcl
    vault server -config=/etc/vault.hcl
  EOF

  tags = {
    Name = "Vault-Server"
  }
}
