# ---------------------------------------------------------------------------------------------------------------------
# AWS SNS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_sns_topic" "notifications" {

  for_each          = var.topics
  name              = each.value.sns_name
  kms_master_key_id = var.kms_keys_data[each.value.key_name].id
  tags = {
    Project     = var.project
    Subproject  = var.subproject
    Environment = var.environment
    Owner       = var.owner
    Createdby   = var.createdby
  }
}
