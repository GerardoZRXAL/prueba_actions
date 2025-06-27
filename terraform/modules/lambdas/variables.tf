# GENERAL
variable "aws_account" {
  type = string
}

variable "region" {
  type        = string
  description = "Infrastructure Deployment Region."
}

#LAMBDA
variable "lambda_config" {
  description = "Configuración de las funciones Lambda"
  type = map(object({
    function_name      = string
    description        = string
    role_name          = string
    handler            = string
    runtime            = string
    memory_size        = number
    timeout            = number
    env_variables      = map(string)
    needs_custom_layer = bool
    s3_bucket          = string
    s3_key             = string
    layers             = list(string)
    needs_layer        = bool
    custom_layer_name  = string
    type               = string
    source_dir         = string
    output_path        = string
    subnet_ids         = list(string)
    security_group_ids = list(string)
    tracing_config     = string
    additional_config  = optional(any)
  }))
}


variable "s3_event_lambda_config" {
  type = map(object({
    action           = string
    principal        = string
    source_s3_bucket = string
    events           = list(string)
    filter_prefix    = string
  }))
}

variable "kms_resources" {
  type        = any
  description = ""
}
