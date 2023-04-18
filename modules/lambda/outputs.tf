output "lambda_role" {
  value = try(aws_iam_role.lambda_role[0].arn, "")
}

