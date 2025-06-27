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

# CodeArtifact
variable "codeartifacts_domain_resources" {
  type = map(object({
    codeartifact_domain_name = string
    kms_key_name             = string
    repositories = optional(list(object({
      name                  = string
      description           = optional(string, "Repositorio creado por Terraform")
      upstream_repositories = optional(list(string), [])
      external_connections  = optional(list(string), []) # Por ejemplo: ["public:npmjs"]
    })), [])
  }))
  description = "List of properties for AWS CodeArtifact Domains and their repositories."
}

# KMS
variable "kms_resources" {
  type        = any
  description = "KMS values for CodeArtifact encription at rest"
}
