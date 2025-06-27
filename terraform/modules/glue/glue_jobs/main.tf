# ---------------------------------------------------------------------------------------------------------------------
# CLOUDWATCH LOGS
# # ---------------------------------------------------------------------------------------------------------------------
# resource "aws_cloudwatch_log_group" "logs_glue_jobs" {
#   for_each = var.glue_etl_config

#   name              = "${each.value.job_name}-logs"
#   retention_in_days = each.value.log_retention
#   kms_key_id        = var.kms_keys_data[each.value.key_name].arn
# }

# Glue Jobs ETL
resource "aws_glue_connection" "source_db" {
  connection_type = "NETWORK"
  name            = var.glue_connection_name

  physical_connection_requirements {
    availability_zone      = var.glue_connection_availability_zone
    security_group_id_list = var.glue_connection_security_group
    subnet_id              = var.glue_connection_subnet_id
  }

}

resource "aws_glue_job" "glue_etl" {
  for_each = var.glue_etl_config

  name              = each.value.job_name
  description       = each.value.job_description
  role_arn          = "arn:aws:iam::${var.aws_account}:role/${each.value.iam_role_name}"
  glue_version      = each.value.glue_version
  number_of_workers = each.value.job_type == "glueetl" ? each.value.num_workers : null
  worker_type       = each.value.job_type == "glueetl" ? each.value.worker_type : null
  max_capacity      = each.value.job_type == "pythonshell" ? each.value.max_capacity : null
  connections       = each.value.connection_enable ? [var.glue_connection_name] : []

  command {
    script_location = each.value.script_location
    name            = each.value.job_type
    python_version  = each.value.job_type == "pythonshell" ? each.value.python_version : null
  }

  default_arguments = each.value.default_arguments

  execution_property {
    max_concurrent_runs = each.value.max_concurrent_runs
  }

}
