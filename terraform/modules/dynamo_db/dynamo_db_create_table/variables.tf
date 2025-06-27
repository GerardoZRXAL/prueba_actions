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

# DynamoDB
variable "dynamo_tables" {
  type = map(object({
    dynamo_table_name     = string
    dynamodb_billing_mode = string
    dynamo_read_capacity  = number
    dynamo_write_capacity = number
    dynamo_hash_key       = string
    dynamo_source_key     = string
    encription_enabled    = optional(bool)
    kms_key_name          = optional(string)
    dynamo_ttl_atribute   = optional(string)
    dynamo_attributes = list(object({
      name = string
      type = string
    }))
  }))
  description = "List of properties for DynamoDB tables."
}

# KMS
variable "kms_resources" {
  type        = any
  description = "KMS values for dynamo db encription at rest"
}