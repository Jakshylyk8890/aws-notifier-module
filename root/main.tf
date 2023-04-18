module "sqs" {
  source         = "../modules/sqs"
  sqs_queue_name = "dev-sqs"
}

module "sns" {
  source         = "../modules/sns"
  sns_topic_name = "dev-sns"
  sqs_arn        = module.sqs.sqs_arn
}

module "dynamodb" {
  source        = "../modules/dynamodb"
  dynamodb_name = "wiz"
}

module "secretmanager" {
  source             = "../modules/secretmanager"
  secretmanager_name = "secret"
  user_name          = "ls"
  user_password      = "lsls"
}

module "lambda" {
  source        = "../modules/lambda"
  source_dir    = "${path.cwd}/functions/servicenow/lambda_function"
  output_path   = "${path.cwd}/functions/servicenow/lambda_function.zip"
  function_name = "servicenow_function"
  role_name     = "ServiceNowRole"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  sqs_arn       = module.sqs.sqs_arn
  sns_arn       = module.sns.sns_arn

  environment_variables = {
    TABLE_NAME = var.table_name
  }
}

module "lambda2" {
  source        = "../modules/lambda"
  source_dir    = "${path.cwd}/functions/wiz/lambda_function"
  output_path   = "${path.cwd}/functions/wiz/lambda_function.zip"
  function_name = "wiz_function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  create_role   = false
  create_policy = false
  role_arn      = module.lambda.lambda_role
  sqs_arn       = module.sqs.sqs_arn
  environment_variables = {
    TABLE_NAME = var.table_name
  }


}

# variable "table_name" {
#   default = "wiz"
# }


