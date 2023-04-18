data "archive_file" "archive" {
  source_dir  = var.source_dir
  output_path = var.output_path
  type        = "zip"
}


data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create_policy && var.create_role ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

    sid = ""
  }
}

data "aws_iam_policy_document" "dynamodb_policy_document" {
  count = var.create_policy ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "lambda_role_logs_policy" {
  count = var.create_policy ? 1 : 0
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "sns_to_sqs_policy" {
  count = var.create_policy ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:SendMessage"
    ]
    resources = [
      var.sqs_arn,
    ]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values = [
        var.sns_arn,
      ]
    }
  }
}
data "aws_iam_policy_document" "secretsmanager_policy" {
  count = var.create_policy ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecret",
      "secretsmanager:TagResource",
      "secretsmanager:UntagResource",
    ]
    resources = ["*"]
  }
}

locals {
  lambda_policies = {
    logs     = try(data.aws_iam_policy_document.lambda_role_logs_policy[0].json, "")
    dynamodb = try(data.aws_iam_policy_document.dynamodb_policy_document[0].json, "")
    sqs      = try(data.aws_iam_policy_document.sns_to_sqs_policy[0].json, "")
    secrets  = try(data.aws_iam_policy_document.secretsmanager_policy[0].json, "")
  }
}

