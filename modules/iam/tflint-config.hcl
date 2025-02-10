# Enable the AWS plugin for TFLint
plugin "aws" {
  enabled = true
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
  version = "0.24.1"
}

# General TFLint settings
config {
  recursive = true  # Scan all Terraform files in subdirectories
}

# Enable AWS rules to enforce best practices
rule "aws_instance_invalid_type" {
  enabled = true
}

rule "aws_s3_bucket_public_access" {
  enabled = true
}

rule "aws_security_group_open_ports" {
  enabled = true
}

rule "aws_iam_policy_no_wildcard" {
  enabled = true
}

# Ensure that security groups do not allow unrestricted access
rule "aws_security_group_ingress_cidr_blocks" {
  enabled = true
}

# Enforce required tags for resources
rule "terraform_module_tag_required" {
  enabled = true
  required_tags = ["Name", "Environment", "Owner"]
}

# Prevent IAM roles from using excessive permissions
rule "aws_iam_role_restricted_permissions" {
  enabled = true
  restricted_actions = [
    "iam:*",
    "s3:*"
  ]
}

# Ensure EKS clusters use recommended instance types
rule "aws_eks_node_group_instance_types" {
  enabled = true
  allowed_types = ["t3.medium", "m5.large", "m5.xlarge"]
}
