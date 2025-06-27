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
variable "short_project" {
  type        = string
  description = "TAG: Create by."
}
variable "domain" {
  type        = string
  description = "TAG: Create by."
}

variable "roles_configurations" {
  type = map(object({
    name                    = string
    policie_name            = string
    description             = string
    assume_role_policy_path = string
    policy_path             = string
    managed_policy_arn      = optional(string)
  }))
}
