resource "aws_lambda_function" "lambda_function" {
  filename         = var.output_path
  function_name    = var.function_name
  role             = try(aws_iam_role.lambda_role[0].arn, var.role_arn)
  handler          = var.handler
  source_code_hash = data.archive_file.archive.output_base64sha256
  runtime          = var.runtime

  environment {
    variables = var.environment_variables
  }
}

resource "aws_iam_role" "lambda_role" {
  count              = var.create_role ? 1 : 0
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy[0].json
}
resource "aws_lambda_event_source_mapping" "lamda_mapping" {
  count = var.create_policy ? 1 : 0
  event_source_arn = var.sqs_arn
  function_name    = aws_lambda_function.lambda_function.arn
}

# resource "aws_lambda_permission" "with_sns" {
#   statement_id  = "AllowExecutionFromSQS"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.lambda_function.function_name
#   principal     = "sqs.amazonaws.com"
#   source_arn    = var.sqs_arn
# }
resource "aws_iam_policy" "lambda_policy" {
  for_each    = { for i, v in local.lambda_policies : i => v if var.create_policy }
  name        = each.key
  description = "The lambda seccretmanager policy"
  policy      = each.value
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  for_each   = { for i, v in local.lambda_policies : i => v if var.create_policy }
  role       = try(aws_iam_role.lambda_role[0].name, var.role_arn)
  policy_arn = aws_iam_policy.lambda_policy[each.key].arn
}