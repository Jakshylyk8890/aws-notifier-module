data "aws_iam_policy_document" "sqs_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
      "sqs:SendMessage"
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sqs_queue.sqs-queue.arn,
    ]

    sid = "__default_statement_ID"
  }
}


# data "aws_iam_policy_document" "lambda_role_sqs_policy" {
#   version = "2012-10-17"

#   statement {
#     effect = "Allow"



#     actions = [
#       "sqs:ChangeMessageVisibility",
#       "sqs:DeleteMessage",
#       "sqs:GetQueueAttributes",
#       "sqs:ReceiveMessage",
#     ]

#     resources = [
#       "*",
#     ]
#   }
# }

