resource "aws_apigatewayv2_api" "sales_api_gateway" {
  name          = "sales-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "sales_api_stage" {
  api_id      = aws_apigatewayv2_api.sales_api_gateway.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "sales_api_integration" {
  api_id          = aws_apigatewayv2_api.sales_api_gateway.id
  description      = "Lambda sales api"

  integration_uri  = aws_lambda_function.sales_api_lambda.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "checkout_route" {
  api_id    = aws_apigatewayv2_api.sales_api_gateway.id
  route_key = "POST /checkout"

  target    = "integrations/${aws_apigatewayv2_integration.sales_api_integration.id}"
}

resource "aws_apigatewayv2_route" "donut_route" {
  api_id    = aws_apigatewayv2_api.sales_api_gateway.id
  route_key = "GET /product/donut"
  
  target    = "integrations/${aws_apigatewayv2_integration.sales_api_integration.id}"
}

resource "aws_lambda_permission" "sales_api_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sales_api_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.sales_api_gateway.execution_arn}/*/*"
}