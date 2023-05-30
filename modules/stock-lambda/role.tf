module "assume_role" {
  source      = "../iam/lambda_assume_role"
  effect       = "Allow"
  role_name   = var.role_name
}

resource "aws_iam_policy" "sqs_get_policy" {
  name        = "stock_sqs_policy"
  description = "Allows get messages to SQS"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "StockSQSRole",
            "Effect": "Allow",
            "Action": [
                "sqs:GetQueueUrl",
                "sqs:GetQueueAttributes",
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage"
            ],
            "Resource": [
                "${var.sales_api_queue_arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "stock_lambda_role_SQS_policy" {
  role       = module.assume_role.name
  policy_arn = aws_iam_policy.sqs_get_policy.arn
}

resource "aws_iam_role_policy_attachment" "stock_lambda_role_basic_execution_policy" {
  role       = module.assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

