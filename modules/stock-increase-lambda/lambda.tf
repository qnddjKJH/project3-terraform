resource "aws_lambda_function" "stock_increase_lambda" {
  function_name = "stock_increase_lambda"
  role          = module.assume_role.role_arn
  handler       = "handler.handler"
  runtime       = "nodejs18.x"
  timeout       = 10

  # Lambda 함수 코드
  filename      = "stock_increase_lambda.zip"
  source_code_hash = filebase64sha256("stock_increase_lambda.zip")

  environment {
    variables = {
      HOSTNAME = var.db_host_name
      USERNAME = var.db_user_name
      PASSWORD = var.db_password
      DATABASE = var.db_database
    }
  }

  # CloudWatch Logs 스트림 생성 설정
  tracing_config {
    mode = "Active"
  }
}

resource "aws_cloudwatch_log_group" "stock_increase_lambda_cloudwatch" {
  name = "/aws/lambda/${aws_lambda_function.stock_increase_lambda.function_name}"

  retention_in_days = 30
}