resource "aws_apigatewayv2_api" "stock_increase_lambda_gateway" {
  name          = "sales-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "stock_increase_lambda_stage" {
  api_id      = aws_apigatewayv2_api.stock_increase_lambda_gateway.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "stock_increase_lambda_integration" {
  api_id          = aws_apigatewayv2_api.stock_increase_lambda_gateway.id
  description      = "Lambda sales api"

  integration_uri  = aws_lambda_function.stock_increase_lambda.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "donut_route" {
  api_id    = aws_apigatewayv2_api.stock_increase_lambda_gateway.id
  route_key = "POST /product/donut"
  
  target    = "integrations/${aws_apigatewayv2_integration.stock_increase_lambda_integration.id}"
}

resource "aws_lambda_permission" "stock_increase_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stock_increase_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.stock_increase_lambda_gateway.execution_arn}/*/*"
}