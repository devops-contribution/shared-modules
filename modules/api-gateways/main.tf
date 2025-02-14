terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Allows any version 5.x.x
    }
  }
}

# Create API Gateway
resource "aws_apigatewayv2_api" "my_api" {
  name          = "secure-api-101"
  protocol_type = "HTTP"
}

# Create API Gateway Stage
resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.my_api.id
  name        = "dev"
  auto_deploy = true
}

# Attach API Gateway to ALB
resource "aws_apigatewayv2_integration" "alb" {
  api_id                 = aws_apigatewayv2_api.my_api.id
  integration_type       = "HTTP_PROXY"
  integration_uri        = var.alb_dns
  integration_method     = "ANY"
}

# Create Route for API Gateway
resource "aws_apigatewayv2_route" "hello_route" {
  api_id    = aws_apigatewayv2_api.my_api.id
  route_key = "GET /api/v1/hi"
  target    = "integrations/${aws_apigatewayv2_integration.alb.id}"
}
