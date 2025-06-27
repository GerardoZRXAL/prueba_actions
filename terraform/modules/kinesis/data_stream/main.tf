# ---------------------------------------------------------------------------------------------------------------------
# STREAM Resources
# ---------------------------------------------------------------------------------------------------------------------

# STREAM CONFIG
resource "aws_kinesis_stream" "stream_resource" {
  for_each         = var.kinesis_data_stream_config
  name             = "${var.project}-kinesis-${var.subproject}-${each.value.stream_name}-${var.environment}"
  shard_count      = each.value.shard_count
  retention_period = each.value.retention_period
  encryption_type  = each.value.encryption_type
  kms_key_id       = each.value.kms_key_name != "" ? lookup(var.kms_resources, each.value.kms_key_name, null) != null ? var.kms_resources[each.value.kms_key_name].key_id : null : null
  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]
  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}

# Local variable that contains Glue job information to use in other modules. This local variable is declared in the outputs module.
locals {
  all_stream_resource = {
    for key, value in aws_kinesis_stream.stream_resource :
    key => { arn_value = value.arn }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS CLOUDWATCH ALARM
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "cloudwatch_alarm" {
  for_each            = var.kinesis_ds_cloudwatch_alarms_config
  alarm_name          = "${var.project}-kinesis-${var.subproject}-${each.value.alarm_name}-${var.environment}"
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold # Adjust this threshold as needed
  alarm_description   = each.value.alarm_description
  alarm_actions       = ["arn:aws:sns:${var.region}:${var.aws_account}:${each.value.sns_name}"]
  treat_missing_data  = "breaching"
  datapoints_to_alarm = each.value.evaluation_periods
  dimensions = {
    StreamName = "${var.project}-kinesis-${var.subproject}-${each.value.kiensis_name}-${var.environment}" # Replace with your actual stream name
  }
  tags = {
    Project     = var.project
    Subproject  = var.subproject
    Environment = var.environment
    Owner       = var.owner
    Createdby   = var.createdby
  }
}