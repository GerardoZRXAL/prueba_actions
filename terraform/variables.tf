# GENERAL
variable "aws_account" {
  type        = string
  description = "The AWS account ID where the infrastructure will be deployed."
}

variable "region" {
  type        = string
  description = "The AWS region where the infrastructure will be deployed."
}

variable "project" {
  type        = string
  description = "TAG : Name of the project (used for tagging resources)."
}

variable "subproject" {
  type        = string
  description = "TAG : Name of the subproject or component"
}

variable "environment" {
  type        = string
  description = "TAG : Deployment environment (e.g., dev, staging, prod)"
}

variable "owner" {
  type        = string
  description = "TAG : Owner or team responsible for the resource (used for tagging resources)"
}

variable "createdby" {
  type        = string
  description = "Entity or tool that created the resource (used for tagging resources)."
}

variable "map_migrated" {
  type        = string
  description = "TAG: AWS migration tag indicating if the resource was migrated (used for tagging resources)."
}


#TAGS 
variable "account_consumer" {
  type        = string
  description = "TAG: AWS account number that will consume the resource or information"
}

variable "role_source" {
  type        = string
  description = "TAG: IAM role name in the source account"
}

variable "role_consumer" {
  type        = string
  description = "TAG: The name of the role in the consumer account"
}
variable "short_project" {
  type        = string
  description = "TAG: Abbreviated name of the project (used for naming conventions and tagging)"
}
variable "short_domain" {
  type        = string
  description = "TAG: Abbreviated domain name associated with the resource (used for naming conventions and tagging)."
}
variable "domain" {
  type        = string
  description = "TAG: Full domain name associated with the resource (used for tagging resources)."
}

# KMS
variable "kms_data" {
  type = map(object({
    alias                   = string
    description             = string
    file_path_policy        = string
    deletion_window_in_days = number
    enable_key_rotation     = bool
    tags                    = map(string)
  }))
}

# S3
variable "buckets_data" {
  type = map(object({
    bucket_name       = string
    key_name          = string
    s3_logging_config = bool
    s3_versioning     = optional(string)
    policy_path       = optional(string)
    mfa_delete        = optional(bool)
  }))
}


# ==================== ENDPOINT =======================
# =====================================================
variable "route_table_id" {
  description = "List of route table IDs to associate with the endpoint"
  type        = list(string)
}

variable "endpoint_configurations" {
  type = map(object({
    endpoin_vpc_id               = string
    endpoint_name                = string
    endpoin_service_name         = string
    endpoint_type                = string
    security_groups              = list(string)
    subnets_ids                  = list(string)
    endpoint_private_dns_enabled = string
    policy_path                  = optional(string)
  }))
}

# Glue Database
variable "glue_database" {
  type = map(object({
    glue_database_name = string
    tags               = map(string)
  }))
}


# Sns
variable "topics" {
  type = map(object({
    sns_name = string
    key_name = string
  }))
}


# IAM Role
variable "roles_configurations" {
  type = map(object({
    name                    = string
    policie_name            = string
    description             = string
    assume_role_policy_path = string
    policy_path             = string
  }))
}


# DynamoDB
variable "dynamo_tables" {
  type = map(object({
    dynamo_table_name     = string
    dynamodb_billing_mode = string
    dynamo_read_capacity  = number
    dynamo_write_capacity = number
    dynamo_hash_key       = string
    dynamo_source_key     = string
    encription_enabled    = optional(bool)
    kms_key_name          = optional(string)
    dynamo_ttl_atribute   = optional(string)
    dynamo_attributes = list(object({
      name = string
      type = string
    }))
  }))
}

# # Dynamo Insert
# variable "dynamo_insert_item" {
#   type = map(object({
#     dynamo_table_name  = string
#     dynamo_hash_key    = string
#     dynamo_source_key  = string
#     dynamo_tables_path = string
#   }))
# }


# GLUE JOBS
variable "glue_connection_name" {
  type        = string
  description = "Name Glue connection"
}

variable "glue_connection_availability_zone" {
  type        = string
  description = "Availability Zone Subred."
}

variable "glue_connection_security_group" {
  type        = list(string)
  description = "Security Group Glue Jobs datalake"
}

variable "glue_connection_subnet_id" {
  type        = string
  description = "Id private Subnet."
}

variable "glue_etl_config" {
  type = map(object({
    job_name            = string
    job_description     = string
    iam_role_name       = string
    glue_version        = string
    num_workers         = number
    worker_type         = string
    max_capacity        = number
    job_type            = string
    python_version      = string
    script_location     = string
    max_concurrent_runs = number
    log_retention       = number
    default_arguments   = any
    key_name            = string
    connection_enable   = bool
  }))
  description = "Configurations for glue roles and policies."
}

# STEP FUNCTIONS

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
