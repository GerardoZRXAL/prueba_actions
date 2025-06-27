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

# Secret Manager
variable "secret_manager" {
  type = map(object({
    secret_name = string
    key_name    = string
  }))
}

# KMS
variable "kms_keys_data" {
  type        = any
  description = "Data for the creation of the keys in AWS KMS"
}