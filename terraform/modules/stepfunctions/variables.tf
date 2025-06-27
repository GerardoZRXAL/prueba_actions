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

#Step Function

variable "step_functions" {
  type = map(object({
    state_machine_name   = string
    file_path_definition = string
    iam_role_name        = string
    job_name             = optional(string)
    sns_name             = string
    lambda_name          = optional(string)
  }))
}

