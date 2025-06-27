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

# S3

variable "lifecycle_data" {
  type = map(object({
    bucket_name = string
    rules = map(object({
      days_expiration = optional(number)
      filter_prefix   = optional(string)
      id              = string
      status          = string
      transition = map(object({
        days          = number
        storage_class = string
      }))
      noncurrent_version_expiration = optional(object({
        noncurrent_days           = number
        newer_noncurrent_versions = number
      }))
    }))
  }))
}

# S3 Bucket
variable "buckets_data" {
  type        = any
  description = "Data for the creation of the bucket in s3"
}
