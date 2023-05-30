output "base_url" {
  value = aws_apigatewayv2_api.sales_api_gateway.api_endpoint
}

output "sales_api_queue_arn" {
  value = aws_sqs_queue.sales_api_queue.arn
}