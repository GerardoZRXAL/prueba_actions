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

# TRANSFER FAMILY

variable "transfer_family_configuration" {
  type = object({
    trans_fam_role_name          = string
    trans_fam_role_file_path     = string
    trans_fam_policy_name        = string
    trans_fam_policy_file_path   = string
    trans_fam_username           = string
    trans_fam_home_directory     = string
    cloudwatch_retention_in_days = optional(number)
    cloudwatch_log_kms_key       = optional(string)
  })
  description = "General settings for Trasnfer Family."
}

# KMS OUTPUT VALUES
variable "kms_resources" {
  type        = any
  description = "KMS values for cloudwatch log group encription"
}