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

# EVENT BRIDGE S3 - LAMBDA
variable "eventbridge_lambda_settings" {
  description = "Lista de configuraciones para las reglas de EventBridge para iniciar funciones lambda"
  type = list(object({
    name                 = string
    description          = string
    s3_bucket_name       = string
    lambda_function_name = string
    event_pattern_prefix = optional(string)
    event_pattern_suffix = optional(string)
  }))
}

variable "enable_bucket_notifications" {
  description = "Habilitar automáticamente las notificaciones de EventBridge para los buckets S3"
  type        = bool
  default     = true
}

