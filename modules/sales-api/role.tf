module "assume_role" {
  source      = "../iam/lambda_assume_role"
  effect       = "Allow"
  role_name   = var.role_name
}

resource "aws_iam_policy" "sns_publish_policy" {
  name        = "sns-publish-policy"
  description = "Allows publishing messages to SNS"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sns:Publish",
      "Resource": "${aws_sns_topic.sales_api_sns.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sales_api_lambda_role_SNS_policy" {
  role       = module.assume_role.name
  policy_arn = aws_iam_policy.sns_publish_policy.arn
}

resource "aws_iam_role_policy_attachment" "sales_api_lambda_role_basic_execution_policy" {
  role       = module.assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

