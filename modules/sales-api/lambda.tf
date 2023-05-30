resource "aws_lambda_function" "sales_api_lambda" {
  function_name = "sales_api_lambda"
  role          = module.assume_role.role_arn
  handler       = "handler.handler"
  runtime       = "nodejs18.x"
  timeout       = 10

  # Lambda 함수 코드
  filename      = "sales_api.zip"
  source_code_hash = filebase64sha256("sales_api.zip")

  environment {
    variables = {
      HOSTNAME = var.db_host_name
      USERNAME = var.db_user_name
      PASSWORD = var.db_password
      DATABASE = var.db_database
      TOPIC_ARN = "${aws_sns_topic.sales_api_sns.arn}"
    }
  }

  # CloudWatch Logs 스트림 생성 설정
  tracing_config {
    mode = "Active"
  }
}

resource "aws_cloudwatch_log_group" "sales_api_cloudwatch" {
  name = "/aws/lambda/${aws_lambda_function.sales_api_lambda.function_name}"

  retention_in_days = 30
}