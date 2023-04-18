variable "sqs_arn" {}
variable "source_dir" {
  description = "Source code of python"
  default     = ""
}
variable "output_path" {
  description = "Output of zip code"
  default     = ""
}
variable "runtime" {}
variable "role_name" {
  default = ""
}
variable "function_name" {}
variable "handler" {}
variable "create_role" {
  default = true
}
variable "create_policy" {
  default = true
}
variable "role_arn" {
  default = null
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "sns_arn" {
  default = ""
}

