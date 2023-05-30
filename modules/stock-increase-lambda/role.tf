module "assume_role" {
  source      = "../iam/lambda_assume_role"
  effect       = "Allow"
  role_name   = var.role_name
}

resource "aws_iam_role_policy_attachment" "sales_api_lambda_role_basic_execution_policy" {
  role       = module.assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

