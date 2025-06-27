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

# Kinesis 

variable "kinesis_data_stream_config" {
  type = map(object({
    stream_name      = string
    shard_count      = number
    retention_period = number
    kms_key_name     = string
    encryption_type  = string
  }))
  description = "Configurations for kinesis data streams."
}

variable "kinesis_ds_cloudwatch_alarms_config" {
  type = map(object({
    alarm_name          = string
    comparison_operator = string
    evaluation_periods  = string
    metric_name         = string
    namespace           = string
    period              = string
    statistic           = string
    threshold           = string
    alarm_description   = string
    kiensis_name        = string
    sns_name            = string
  }))
  description = "Configurations for kinesis data streams."
}

variable "kms_resources" {
  type        = any
  description = "kms key for kinesis data stream encription"
}