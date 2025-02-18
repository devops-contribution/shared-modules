terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Allows any version 5.x.x
    }
  }
}

# Create an HTTP API
resource "aws_apigatewayv2_api" "example" {
  name          = "${var.customer}-http-api"
  protocol_type = "HTTP"
  description   = "Example HTTP API Gateway"
}

# "/api/v1/hi" route
resource "aws_apigatewayv2_route" "api_v1_hi_route" {
  api_id     = aws_apigatewayv2_api.example.id
  route_key  = "GET /api/v1/hi"
  target     = "integrations/${aws_apigatewayv2_integration.api_v1_hi_integration.id}"
}

# "/" route
resource "aws_apigatewayv2_route" "root_route" {
  api_id     = aws_apigatewayv2_api.example.id
  route_key  = "GET /"
  target     = "integrations/${aws_apigatewayv2_integration.root_integration.id}"
}
 
# Create a VPC Link
resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "${var.customer}-vpc-link"
  security_group_ids = [var.vpc_link_security_group_id]
  subnet_ids         = var.subnet_ids
}

# Integration for the "/" route
resource "aws_apigatewayv2_integration" "root_integration" {
  api_id                 = aws_apigatewayv2_api.example.id
  integration_type       = "HTTP_PROXY"
  integration_uri        = var.alb_dns
  integration_method     = "GET"
  payload_format_version = "1.0"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.vpc_link.id
}

# Integration for the "/api/v1/hi" route
resource "aws_apigatewayv2_integration" "api_v1_hi_integration" {
  api_id                 = aws_apigatewayv2_api.example.id
  integration_type       = "HTTP_PROXY"
  integration_uri        = "${var.alb_dns}/api/v1/hi"
  integration_method     = "GET"
  payload_format_version = "1.0"
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.vpc_link.id
}

# "dev" stage for the HTTP API
resource "aws_apigatewayv2_stage" "dev_stage" {
  api_id     = aws_apigatewayv2_api.example.id
  name = "dev"
  auto_deploy = true
}
