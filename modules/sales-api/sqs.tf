# SQS Queue
resource "aws_sqs_queue" "sales_api_queue" {
  name = "sales_api_queue"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sales_api_queue_dlq.arn
    maxReceiveCount     = 3
  })
}

# DLQ (Dead Letter Queue)
resource "aws_sqs_queue" "sales_api_queue_dlq" {
  name = "sales_api_queue_dlq"
}

# SQS Redrive Policy (connects SQS with DLQ)
# Condition 부분은 SNS 의 해당 토픽에서 온 메시지만을 DLQ 에 보내도록 제한
resource "aws_sqs_queue_policy" "sales_api_queue_policy" {
  queue_url = aws_sqs_queue.sales_api_queue.id
  policy    = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "RedrivePolicy",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "SQS:SendMessage",
        "Resource": "${aws_sqs_queue.sales_api_queue_dlq.arn}",
        "Condition": {
          "ArnEquals": {
            "aws:SourceArn": "${aws_sns_topic.sales_api_sns.arn}"
          }
        }
      },
      {
        "Sid": "AllowSNSPublish",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "sqs:SendMessage",
        "Resource": "${aws_sqs_queue.sales_api_queue.arn}",
        "Condition": {
          "ArnEquals": {
            "aws:SourceArn": "${aws_sns_topic.sales_api_sns.arn}"
          }
        }
      }
    ]
  })
}