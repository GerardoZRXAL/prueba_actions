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

# ECR
variable "ecr_mapping_resources" {
  type = map(object({
    ecr_repository_name = string
    ecr_tag_mutability  = string
    ecr_image_scanning  = bool
    ecr_encryption_type = string
    kms_key_name        = string
  }))
  description = "List of properties for ECR."
}

# KMS
variable "kms_resources" {
  type        = any
  description = "KMS values for ECR encription at rest"
}