# SNS Topic
resource "aws_sns_topic" "sales_api_sns" {
  name = "sales_api_sns"
}

# SNS Subscription
resource "aws_sns_topic_subscription" "stock_subscription" {
  topic_arn = aws_sns_topic.sales_api_sns.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sales_api_queue.arn
}