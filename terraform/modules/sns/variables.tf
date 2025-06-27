# General

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


# Sns

variable "topics" {
  type = map(object({
    sns_name = string
    key_name = string
  }))
}

# KMS
variable "kms_keys_data" {
  type        = any
  description = "Data for the creation of the keys in AWS KMS"
}