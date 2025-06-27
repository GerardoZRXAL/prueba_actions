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

# EVENT BRIDGE
variable "eventbridge_settings" {
  type = map(object({
    cron_name           = string
    description         = string
    schedule_expression = string
    is_enabled          = string
    run_command_targets = string
    step_functions_name = string
    role_name           = string
  }))
}
