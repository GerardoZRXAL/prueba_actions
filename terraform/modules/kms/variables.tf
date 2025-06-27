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

variable "account_consumer" {
  type        = string
  description = "TAG: The number of the account that will be consume the info"
}

variable "role_source" {
  type        = string
  description = "TAG: The name of the role in the source account"
}

variable "role_consumer" {
  type        = string
  description = "TAG: The name of the role in the consumer account"
}

# KMS

variable "kms_data" {
  type = map(object({
    alias                   = string
    description             = string
    file_path_policy        = string
    deletion_window_in_days = number
    enable_key_rotation     = bool
    tags                    = map(string)
  }))
}

