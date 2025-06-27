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

# Firehose config
variable "kinesis_firehose_config" {
  type = map(object({
    firehose_name          = string
    kinesis_ds_source_name = string
    destination            = string
    firehose_role_name     = string
    s3_bucket              = string
    lambda_name_to_process = string
    glue_database          = string
    glue_table_name        = string
    kms_key_name           = string
  }))
  description = "Configurations for firehose data stream."
}

variable "kms_resources" {
  type        = any
  description = "kms key for kinesis data stream encription"
}
