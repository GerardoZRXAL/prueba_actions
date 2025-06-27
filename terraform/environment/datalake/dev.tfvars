# GENERAL VARIABLES
aws_account      = "026891307083"
region           = "us-east-1"
project          = "ftc"
subproject       = "dlk"
environment      = "dev"
owner            = "XalDigital"
createdby        = "TF"
map_migrated     = "mig"
account_consumer = ""
role_source      = ""
role_consumer    = ""
short_project    = "ftc"
short_domain     = "dlk"
domain           = "datalake"


# KMS Key
kms_data = {
  s3-key = {
    alias                   = "s3-key"
    description             = "KMS key used for server-side encryption of S3 buckets in the data lake. This key should have appropriate policies for cross-account access if the data lake spans multiple AWS accounts."
    file_path_policy        = "policies/datalake/kms_policy.json"
    deletion_window_in_days = 7
    enable_key_rotation     = true
    tags                    = {}
  },
  sns-key = {
    alias                   = "sns-key"
    description             = "KMS key used for server-side encryption of SNS topic in the data lake."
    file_path_policy        = "policies/datalake/kms_policy.json"
    deletion_window_in_days = 7
    enable_key_rotation     = true
    tags                    = {}
  },
  dynamo-key = {
    alias                   = "dynamo-key"
    description             = "KMS key used for server-side encryption of DynamoDb tables in the data lake."
    file_path_policy        = "policies/datalake/kms_policy.json"
    deletion_window_in_days = 7
    enable_key_rotation     = true
    tags                    = {}
  },
  log-key = {
    alias                   = "log-key"
    description             = "KMS key used for server-side encryption of CloudWatch Log Groups."
    file_path_policy        = "policies/datalake/kms_policy.json"
    deletion_window_in_days = 7
    enable_key_rotation     = true
    tags                    = {}
  },
}


# S3
buckets_data = {
  athena_zone_bucket = {
    bucket_name       = "fortacero-s3-athena-useast1-dev"
    key_name          = "s3-key"
    s3_versioning     = "Suspended"
    s3_logging_config = false
  },
  common_artifacts_bucket = {
    bucket_name       = "fortacero-s3-artifacts-useast1-dev"
    key_name          = "s3-key"
    s3_versioning     = "Suspended"
    s3_logging_config = false
  },
  staging_zone_bucket = {
    bucket_name       = "fortacero-s3-staging-useast1-dev"
    key_name          = "s3-key"
    s3_versioning     = "Suspended"
    s3_logging_config = false
    # policy_path       = "policies/commons/s3_bucket_staging_policy_dev.json"
  },
}

# ENDPOINT
route_table_id = ["rtb-0a039dcb2d6b15c11", "rtb-09ebbf9549dc17145"]
endpoint_configurations = {
  s3-endpoint = {
    endpoin_vpc_id               = "vpc-04b0ce7c7b241a56d"
    endpoint_name                = "s3-endpoint"
    endpoin_service_name         = "com.amazonaws.us-east-1.s3"
    endpoint_type                = "Gateway"
    security_groups              = null
    subnets_ids                  = null
    endpoint_private_dns_enabled = "false"
    policy_path                  = "policies/datalake/vpc_endpoint_s3_policy.json"
  },
  dynamo-endpoint = {
    endpoin_vpc_id               = "vpc-04b0ce7c7b241a56d"
    endpoint_name                = "dynamo-endpoint"
    endpoin_service_name         = "com.amazonaws.us-east-1.dynamodb"
    endpoint_type                = "Gateway"
    security_groups              = null
    subnets_ids                  = null
    endpoint_private_dns_enabled = "false"
    policy_path                  = "policies/datalake/vpc_endpoint_dynamo_policy.json"
  }
}

# GLUE DATABASE
glue_database = {
  ftc_dlk_raw_dev = {
    glue_database_name = "ftc_dlk_raw_dev"
    tags = {
    }
  },
  ftc_dlk_raw_dev = {
    glue_database_name = "ftc_dlk_staging_dev"
    tags = {
    }
  },
  ftc_dlk_semantic_dev = {
    glue_database_name = "ftc_dlk_semantic_dev"
    tags = {
    }
  },
}

# SNS
topics = {
  ftc-sns-dlk-compacting-notification-dev = {
    sns_name = "ftc-sns-dlk-compacting-notification-dev"
    key_name = "sns-key"
  },
}

# IAM
roles_configurations = {
  ftc-iam-dlk-compaction-job-dev = {
    name                    = "ftc-iam-dlk-compaction-job-dev"
    policie_name            = "ftc-iam-dlk-compaction-job-dev"
    description             = "Role used to perform the compaction of the table."
    assume_role_policy_path = "roles/glue_role.json"
    policy_path             = "policies/datalake/glue_policy_compaction_stg.json"
  },
  ftc-iam-dlk-sap-orchestration-sf-dev = {
    name                    = "ftc-iam-dlk-sap-orchestration-sf-dev"
    policie_name            = "ftc-iam-dlk-sap-orchestration-sf-dev"
    description             = "This role will allow of Step functions machines for extraction and compaction"
    assume_role_policy_path = "roles/stepfunction_role.json"
    policy_path             = "policies/datalake/step_function_orchestration_policy.json"
  },
  ftc-iam-dlk-trigger-orchestration-cron-dev = {
    name                    = "ftc-iam-dlk-trigger-orchestration-cron-dev"
    policie_name            = "ftc-iam-dlk-trigger-orchestration-cron-dev"
    description             = "Role assumed by EventBridge, allowing it to trigger the Step Function."
    assume_role_policy_path = "roles/event_bridge_role.json"
    policy_path             = "policies/datalake/event_bridge_policy.json"
  },
}

# DynamoDB
dynamo_tables = {
  ftc-dynamo-dlk-compaction-config-dev = {
    dynamo_table_name     = "ftc-dynamo-dlk-compaction-config-dev"
    dynamodb_billing_mode = "PAY_PER_REQUEST"
    dynamo_read_capacity  = null
    dynamo_write_capacity = null
    dynamo_hash_key       = "process_id"
    dynamo_source_key     = "process_name"
    encription_enabled    = true
    kms_key_name          = "dynamo-key"
    dynamo_attributes = [
      { name = "process_id", type = "S" },
      { name = "process_name", type = "S" }
    ]
  },
  ftc-dynamo-dlk-update-metadata-config-dev = {
    dynamo_table_name     = "ftc-dynamo-dlk-update-metadata-config-dev"
    dynamodb_billing_mode = "PAY_PER_REQUEST"
    dynamo_read_capacity  = null
    dynamo_write_capacity = null
    dynamo_hash_key       = "process_id"
    dynamo_source_key     = "process_name"
    encription_enabled    = true
    kms_key_name          = "dynamo-key"
    dynamo_attributes = [
      { name = "process_id", type = "S" },
      { name = "process_name", type = "S" }
    ]
  },
}


# # Dynamo Insert
# dynamo_insert_item = {
#   ftc-dynamo-dlk-compaction-config-dev = {
#     dynamo_table_name  = "ftc-dynamo-dlk-compaction-config-dev"
#     dynamo_hash_key    = "process_id"
#     dynamo_source_key  = "process_name"
#     dynamo_tables_path = "resources/dynamo_compaction/validations"
#   },
# }


# Glue Connection
glue_connection_name              = "ftc-glue-dlk-compaction-connection-dev"
glue_connection_availability_zone = "us-east-1b"
glue_connection_security_group    = ["sg-05bbc0d71eb526a28"]
glue_connection_subnet_id         = "subnet-03e10b208202028a9"

# Glue Job Definition
glue_etl_config = {
  ftc-glue-dlk-odata-vbrk-compaction-dev = {
    job_name            = "ftc-glue-dlk-odata-vbrk-compaction-dev"
    job_description     = "This JOB allows compacting the information from the odata_vbrk table in the RAW layer to the STG layer of the data lake. The information comes from  SAP ODATA and is stored in the Iceberg format."
    iam_role_name       = "ftc-iam-dlk-compaction-job-dev"
    glue_version        = "4.0"
    num_workers         = 2
    worker_type         = "G.1X"
    max_capacity        = 0.0625
    job_type            = "glueetl"
    python_version      = ""
    script_location     = "s3://fortacero-s3-artifacts-useast1-dev/glue/drivers/compaction/driver_compaction_iceberg.py"
    max_concurrent_runs = 1
    log_retention       = 30
    default_arguments = {
      "--additional-python-modules"        = "paramiko,pandas,watchtower,openpyxl"
      "--enable-glue-datacatalog"          = "true"
      "--enable-continuous-cloudwatch-log" = "true"
      "--enable-continuous-log-filter"     = "true"
      "--enable-metrics"                   = "false"
      "--extra-py-files"                   = "s3://fortacero-s3-artifacts-useast1-dev/glue/general_utils/all_utils.zip"
      "--extra-jars"                       = null
      "--job-language"                     = "python"
      "--TempDir"                          = "s3://fortacero-s3-artifacts-useast1-dev/glue/jobs/temporary/"
      "--conf"                             = "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions"
      "--datalake-formats"                 = "iceberg"
      "--DYNAMO_DB_ID"                     = "FTC-CONFIG-001"
      "--DYNAMO_DB_TABLE_NAME"             = "ftc-dynamo-dlk-compaction-config-dev"
      "--RAW_BUCKET"                       = "dlk-fortacero-prod-s3-landing"
      "--STAGING_BUCKET"                   = "fortacero-s3-staging-useast1-dev"
      "--ATHENA_BUCKET"                    = "fortacero-s3-athena-useast1-dev"
      "--DYNAMO_DB_TABLE_NAME_METADATA"    = "ftc-dynamo-dlk-update-metadata-config-dev"
      "--S3_PREFIX_QUALITY"                = ""
      "--enable-auto-scaling"              = "true"
      "--job-bookmark-option"              = "job-bookmark-disable"
      "--enable-job-insights"              = "true"
      "--LOG_GROUP_NAME"                   = "ftc-glue-dlk-log-compactions-dev"
    },
    key_name          = "log-key"
    connection_enable = true
  },
  ftc-glue-dlk-odata-vbrp-compaction-dev = {
    job_name            = "ftc-glue-dlk-odata-vbrp-compaction-dev"
    job_description     = "This JOB allows compacting the information from the odata_vbrp table in the RAW layer to the STG layer of the data lake. The information comes from  SAP ODATA and is stored in the Iceberg format."
    iam_role_name       = "ftc-iam-dlk-compaction-job-dev"
    glue_version        = "4.0"
    num_workers         = 2
    worker_type         = "G.1X"
    max_capacity        = 0.0625
    job_type            = "glueetl"
    python_version      = ""
    script_location     = "s3://fortacero-s3-artifacts-useast1-dev/glue/drivers/compaction/driver_compaction_iceberg.py"
    max_concurrent_runs = 1
    log_retention       = 30
    default_arguments = {
      "--additional-python-modules"        = "paramiko,pandas,watchtower,openpyxl"
      "--enable-glue-datacatalog"          = "true"
      "--enable-continuous-cloudwatch-log" = "true"
      "--enable-continuous-log-filter"     = "true"
      "--enable-metrics"                   = "false"
      "--extra-py-files"                   = "s3://fortacero-s3-artifacts-useast1-dev/glue/general_utils/all_utils.zip"
      "--extra-jars"                       = null
      "--job-language"                     = "python"
      "--TempDir"                          = "s3://fortacero-s3-artifacts-useast1-dev/glue/jobs/temporary/"
      "--conf"                             = "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions"
      "--datalake-formats"                 = "iceberg"
      "--DYNAMO_DB_ID"                     = "FTC-CONFIG-002"
      "--DYNAMO_DB_TABLE_NAME"             = "ftc-dynamo-dlk-compaction-config-dev"
      "--RAW_BUCKET"                       = "dlk-fortacero-prod-s3-landing"
      "--STAGING_BUCKET"                   = "fortacero-s3-staging-useast1-dev"
      "--ATHENA_BUCKET"                    = "fortacero-s3-athena-useast1-dev"
      "--DYNAMO_DB_TABLE_NAME_METADATA"    = "ftc-dynamo-dlk-update-metadata-config-dev"
      "--S3_PREFIX_QUALITY"                = ""
      "--enable-auto-scaling"              = "true"
      "--job-bookmark-option"              = "job-bookmark-disable"
      "--enable-job-insights"              = "true"
      "--LOG_GROUP_NAME"                   = "ftc-glue-dlk-log-compactions-dev"
    },
    key_name          = "log-key"
    connection_enable = true
  },
  ftc-glue-dlk-sap-connection-compaction-dev = {
    job_name            = "ftc-glue-dlk-sap-connection-compaction-dev"
    job_description     = "This job was created to validate the connection and data extraction from the Glue Job service to an SAP OData source."
    iam_role_name       = "ftc-iam-dlk-compaction-job-dev"
    glue_version        = "4.0"
    num_workers         = 2
    worker_type         = "G.1X"
    max_capacity        = 0.0625
    job_type            = "glueetl"
    python_version      = ""
    script_location     = "s3://fortacero-s3-artifacts-useast1-dev/glue/drivers/extraction/driver_extraction.py"
    max_concurrent_runs = 1
    log_retention       = 30
    default_arguments = {
      "--additional-python-modules"        = "paramiko,pandas,watchtower,openpyxl"
      "--enable-glue-datacatalog"          = "true"
      "--enable-continuous-cloudwatch-log" = "true"
      "--enable-continuous-log-filter"     = "true"
      "--enable-metrics"                   = "false"
      "--extra-py-files"                   = "s3://fortacero-s3-artifacts-useast1-dev/glue/general_utils/all_utils.zip"
      "--extra-jars"                       = null
      "--job-language"                     = "python"
      "--TempDir"                          = "s3://fortacero-s3-artifacts-useast1-dev/glue/jobs/temporary/"
      "--conf"                             = "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions"
      "--datalake-formats"                 = "iceberg"
      "--DYNAMO_DB_ID"                     = "FTC-CONFIG-001"
      "--DYNAMO_DB_TABLE_NAME"             = "ftc-dynamo-dlk-compaction-config-dev"
      "--RAW_BUCKET"                       = "dlk-fortacero-prod-s3-landing"
      "--STAGING_BUCKET"                   = "fortacero-s3-staging-useast1-dev"
      "--ATHENA_BUCKET"                    = "fortacero-s3-athena-useast1-dev"
      "--DYNAMO_DB_TABLE_NAME_METADATA"    = "ftc-dynamo-dlk-update-metadata-config-dev"
      "--S3_PREFIX_QUALITY"                = ""
      "--enable-auto-scaling"              = "true"
      "--job-bookmark-option"              = "job-bookmark-disable"
      "--enable-job-insights"              = "true"
      "--LOG_GROUP_NAME"                   = "ftc-glue-dlk-log-compactions-dev"
    },
    key_name          = "log-key"
    connection_enable = true
  },
}

# STEP FUNCTIONS
step_functions = {
  ftc-sf-dlk-vbrp-dev = {
    state_machine_name   = "ftc-sf-dlk-vbrp-dev"
    file_path_definition = "resources/step_function_definition/step_function_demo.json"
    iam_role_name        = "ftc-iam-dlk-sap-orchestration-sf-dev"
    job_name             = "ftc"
    sns_name             = "ftc-sns-dlk-compacting-notification-dev"
  },
  ftc-sf-dlk-vbrk-dev = {
    state_machine_name   = "ftc-sf-dlk-vbrk-dev"
    file_path_definition = "resources/step_function_definition/step_function_demo.json"
    iam_role_name        = "ftc-iam-dlk-sap-orchestration-sf-dev"
    job_name             = "ftc"
    sns_name             = "ftc-sns-dlk-compacting-notification-dev"
  },
}

eventbridge_settings = {
  CONFIG-001 = {
    cron_name           = "ftc-cron-dlk-driver-vbrp-sf-dev",
    description         = "Cron rule scheduled for the execution.",
    schedule_expression = "cron(0 * * * ? *)",
    is_enabled          = "DISABLED",
    run_command_targets = "",
    step_functions_name = "ftc-sf-dlk-vbrp-dev"
    role_name           = "ftc-iam-dlk-trigger-orchestration-cron-dev"
  },
  CONFIG-002 = {
    cron_name           = "ftc-cron-dlk-driver-vbrk-sf-dev",
    description         = "Cron rule scheduled for the execution.",
    schedule_expression = "cron(0 * * * ? *)",
    is_enabled          = "DISABLED",
    run_command_targets = "",
    step_functions_name = "ftc-sf-dlk-vbrk-dev"
    role_name           = "ftc-iam-dlk-trigger-orchestration-cron-dev"
  },
}
