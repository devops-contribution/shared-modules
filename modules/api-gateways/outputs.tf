output "api_gateway_url" {
  value = "https://${aws_apigatewayv2_api.example.id}.execute-api.${var.region}.amazonaws.com/dev/"
}
