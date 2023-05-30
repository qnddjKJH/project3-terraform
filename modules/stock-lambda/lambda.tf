resource "aws_lambda_function" "stock_lambda" {
  function_name = "stock_lambda"
  role          = module.assume_role.role_arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout       = 10

  # Lambda 함수 코드
  filename      = "stock_lambda.zip"
  source_code_hash = filebase64sha256("stock_lambda.zip")

  environment {
    variables = {
      CALLBACK_URL = var.callback_Url
    }
  }

  # CloudWatch Logs 스트림 생성 설정
  tracing_config {
    mode = "Active"
  }
}

resource "aws_cloudwatch_log_group" "stock_lambda_cloudwatch" {
  name = "/aws/lambda/${aws_lambda_function.stock_lambda.function_name}"

  retention_in_days = 30
}

# SQS 이벤트 추가
resource "aws_lambda_event_source_mapping" "out_of_stock_event_mapping" {
  event_source_arn  = var.sales_api_queue_arn
  function_name     = aws_lambda_function.stock_lambda.arn
  batch_size        = 1
}