resource "aws_sqs_queue" "sqs-queue" {
  name                       = var.sqs_queue_name
  visibility_timeout_seconds = 300

  tags = {
    Environment = "dev"
  }
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  queue_url = aws_sqs_queue.sqs-queue.id
  policy    = data.aws_iam_policy_document.sqs_policy.json
}