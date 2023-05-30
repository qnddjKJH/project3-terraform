output "stock_increase_url" {
  value = aws_apigatewayv2_api.stock_increase_lambda_gateway.api_endpoint
}