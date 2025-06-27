# GENERAL
variable "aws_account" {
  type = string
}

variable "region" {
  type        = string
  description = "Infrastructure Deployment Region."
}

variable "project" {
  type        = string
  description = "TAG : Name of the project."
}

variable "subproject" {
  type        = string
  description = "TAG : Name of the subproject."
}

variable "environment" {
  type        = string
  description = "TAG : Environment or deployment environment."
}

variable "owner" {
  type        = string
  description = "TAG : Owner."
}

variable "createdby" {
  type        = string
  description = "TAG: Create by."
}

# S3 Event

variable "lambda_permission_setting" {
  type = map(object({
    function_name = string
    statement_id  = string
    action        = string
    bucket_arn    = string
  }))
}

variable "lambda_bucket_notification_setting" {
  type = map(object({
    bucket_name = string
    event_lambda_function = map(object({
      function_arn  = string
      filter_prefix = string
      filter_suffix = string
    }))
  }))
}
