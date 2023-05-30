variable "service_name" {
  description = "The AWS service name to allow in the assume role policy"
  type        = string
  default     = "lambda.amazonaws.com"
}

variable "effect" {
  description = "The effect of the assume role policy"
  type        = string
  default     = "Allow"
}

variable "role_name" {
  description = "The role name of the assume role policy"
  type        = string
  default     = "assumeRole"
}

resource "aws_iam_role" "assume_role" {
  name        = var.role_name
  description = "Assume role policy"
  assume_role_policy       = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "${var.effect}",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "apigateway.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

output "role_arn" {
  value = aws_iam_role.assume_role.arn
}

output "name" {
  value = aws_iam_role.assume_role.name
}