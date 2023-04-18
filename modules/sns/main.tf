#AWS SNS 
resource "aws_sns_topic" "aws_sns" {
  name = var.sns_topic_name
}
# AWS SNS TOPIC SUBSCRIPTION
resource "aws_sns_topic_subscription" "results_updates_sqs_target" {
  topic_arn = aws_sns_topic.aws_sns.arn
  protocol  = "sqs"
  endpoint  = var.sqs_arn #aws_sqs_queue.results_updates_queue.arn
}
#AWS SNS POLICY
resource "aws_sns_topic_policy" "results_updates_sns_policy" {
  arn    = aws_sns_topic.aws_sns.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}
