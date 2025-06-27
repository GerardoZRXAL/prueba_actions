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

# CRAWLERS
variable "glue_crawler_config" {
  description = "Configuración de los Glue Crawlers"
  type = map(object({
    crawler_name   = string
    database_name  = string
    role_arn       = string
    s3_target_path = string
    jdbc_target = object({
      connection_name = string
      path            = string
      exclusions      = list(string)
    })
    dynamodb_target = string
    catalog_target = object({
      database_name = string
      tables        = list(string)
    })
    recrawl_behavior = string
    schedule         = string
    schema_change_policy = object({
      update_behavior = string
      delete_behavior = string
    })
    configuration = string
  }))
}
