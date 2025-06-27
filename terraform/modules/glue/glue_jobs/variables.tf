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

# Glue 
variable "glue_connection_name" {
  type        = string
  description = "Name Glue connection"
}

variable "glue_connection_availability_zone" {
  type        = string
  description = "Availability Zone Subred."
}

variable "glue_connection_security_group" {
  type        = list(string)
  description = "Security Group Glue Jobs datalake"
}

variable "glue_connection_subnet_id" {
  type        = string
  description = "Id private Subnet."
}

variable "glue_etl_config" {
  type = map(object({
    job_name            = string
    job_description     = string
    iam_role_name       = string
    glue_version        = string
    num_workers         = number
    worker_type         = string
    max_capacity        = number
    job_type            = string
    python_version      = string
    script_location     = string
    max_concurrent_runs = number
    log_retention       = number
    default_arguments   = any
    key_name            = string
    connection_enable   = bool
  }))
  description = "Configurations for glue roles and policies."
}

# KMS
variable "kms_keys_data" {
  type        = any
  description = "Data for the creation of the keys in AWS KMS"
}
