# General
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
  description = "TAG : Owner of the deployment."
}

variable "createdby" {
  type        = string
  description = "TAG : Name of the IaC tool used to deploy."
}

variable "dynamo_insert_item" {
  type = map(object({
    dynamo_table_name  = string
    dynamo_hash_key    = string
    dynamo_source_key  = string
    dynamo_tables_path = string
  }))
}
