plugin "aws" {
  enabled = true
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
  version = "0.4.0"
}

# Enable built-in AWS rules
rule "aws_instance_invalid_type" {
  enabled = true
}

rule "aws_security_group_ingress_cidr_blocks" {
  enabled = true
}

# Custom rule: Ensure S3 Buckets are private
rule "aws_s3_bucket_private" {
  enabled = true
}

# Custom rule: Ensure tags are always defined
rule "terraform_module_tag_required" {
  enabled = true
  required_tags = ["Name", "Environment", "Owner"]
}

# Custom rule: Prevent usage of sensitive IAM actions
rule "aws_iam_policy_restricted_actions" {
  enabled = true
  restricted_actions = [
    "iam:*",         # Prevent wildcard permissions
    "s3:*",          # Prevent full S3 access
    "ec2:*"          # Prevent full EC2 access
  ]
}
