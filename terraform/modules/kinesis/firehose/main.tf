# # ---------------------------------------------------------------------------------------------------------------------
# # IAM Role
# # ---------------------------------------------------------------------------------------------------------------------
# resource "aws_iam_role" "data_stream_definition_role" {
#   for_each           = var.kinesis_firehose_definition_role
#   name               = "${var.project}-iam-${var.subproject}-${each.value.voi_kinesis_firehose_role_name}-${var.environment}"
#   description        = each.value.voi_kinesis_firehose_role_description
#   assume_role_policy = file(each.value.voi_kinesis_firehose_role_file_path)

# }

# resource "aws_iam_role_policy" "job_definition_policy" {
#   for_each = var.kinesis_firehose_definition_role
#   name     = "${var.project}-iam-${var.subproject}-${each.value.voi_kinesis_firehose_policy_name}-${var.environment}"
#   role     = aws_iam_role.data_stream_definition_role[each.key].id
#   policy = templatefile(
#     each.value.voi_kinesis_firehose_policy_file_path,
#     {
#       VAR_REPLACE_aws_account = var.aws_account,
#       VAR_REPLACE_region      = var.region,
#       VAR_REPLACE_project     = var.project,
#       VAR_REPLACE_subproject  = var.subproject,
#       VAR_REPLACE_environment = var.environment
#     }
#   )
# }



# ---------------------------------------------------------------------------------------------------------------------
# STREAM Resources
# ---------------------------------------------------------------------------------------------------------------------

# STREAM CONFIG
resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  for_each    = var.kinesis_firehose_config
  name        = "${var.project}-kinesis-${var.subproject}-${each.value.firehose_name}-${var.environment}"
  destination = each.value.destination
  # # Configuración de cifrado
  # server_side_encryption {
  #   enabled     = lookup(var.kms_resources, each.value.kms_key_name, null) != null
  #   key_type    = "CUSTOMER_MANAGED_CMK"
  #   key_arn     = lookup(var.kms_resources, each.value.kms_key_name, null) != null ? var.kms_resources[each.value.kms_key_name].arn : null
  # }
  kinesis_source_configuration {
    kinesis_stream_arn = "arn:aws:kinesis:${var.region}:${var.aws_account}:stream/${var.project}-kinesis-${var.subproject}-${each.value.kinesis_ds_source_name}-${var.environment}"
    role_arn           = "arn:aws:iam::${var.aws_account}:role/${var.project}-iam-${var.subproject}-${each.value.firehose_role_name}-${var.environment}"
  }
  extended_s3_configuration {
    role_arn           = "arn:aws:iam::${var.aws_account}:role/${var.project}-iam-${var.subproject}-${each.value.firehose_role_name}-${var.environment}"
    bucket_arn         = "arn:aws:s3:::${each.value.s3_bucket}"
    buffering_size     = 128
    buffering_interval = 180
    custom_time_zone   = "America/Mexico_City"
    dynamic_partitioning_configuration {
      enabled = "true"
    }
    prefix              = "tealium/!{partitionKeyFromQuery:source_tbl_name}/extraction/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/"
    error_output_prefix = "tealium/kinesis/errors/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/hour=!{timestamp:HH}/!{firehose:error-output-type}/"
    processing_configuration {
      enabled = "true"
      processors {
        type = "Lambda"
        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "arn:aws:lambda:${var.region}:${var.aws_account}:function:${each.value.lambda_name_to_process}"
        }
        parameters {
          parameter_name  = "NumberOfRetries"
          parameter_value = "3"
        }
        parameters {
          parameter_name  = "BufferSizeInMBs"
          parameter_value = "1"
        }
        parameters {
          parameter_name  = "BufferIntervalInSeconds"
          parameter_value = "60"
        }
      }
      processors {
        type = "MetadataExtraction"
        parameters {
          parameter_name  = "JsonParsingEngine"
          parameter_value = "JQ-1.6"
        }
        parameters {
          parameter_name  = "MetadataExtractionQuery"
          parameter_value = "{source_tbl_name:.source_tbl_name}"
        }
      }
    }
    data_format_conversion_configuration {
      enabled = "true"
      input_format_configuration {
        deserializer {
          hive_json_ser_de {}
        }
      }

      output_format_configuration {
        serializer {
          parquet_ser_de {}
        }
      }
      schema_configuration {
        database_name = each.value.glue_database
        table_name    = each.value.glue_table_name
        role_arn      = "arn:aws:iam::${var.aws_account}:role/${var.project}-iam-${var.subproject}-${each.value.firehose_role_name}-${var.environment}"
      }
    }
  }
}