# ---------------------------------------------------------------------------------------------------------------------
# AWS KMS MODULE FOR CREATING AND CONFIGURING SERVICE RESOURCES.
# ---------------------------------------------------------------------------------------------------------------------


resource "aws_kms_key" "kms_key" {
  for_each = var.kms_data

  description             = each.value.description
  deletion_window_in_days = each.value.deletion_window_in_days
  enable_key_rotation     = each.value.enable_key_rotation != null ? each.value.enable_key_rotation : false
  policy = templatefile(
    each.value.file_path_policy,
    {
      VAR_REPLACE_aws_account      = var.aws_account,
      VAR_REPLACE_region           = var.region,
      VAR_REPLACE_project          = var.project,
      VAR_REPLACE_subproject       = var.subproject,
      VAR_REPLACE_environment      = var.environment,
      VAR_REPLACE_account_consumer = var.account_consumer,
      VAR_REPLACE_role_source      = var.role_source,
      VAR_REPLACE_role_consumer    = var.role_consumer
    }
  )
  tags = each.value.tags
}

# SET ALIAS TO KMS
resource "aws_kms_alias" "kms_key_alias" {
  for_each      = var.kms_data
  name          = "alias/${var.project}-${var.subproject}-${each.value.alias}-${var.environment}"
  target_key_id = aws_kms_key.kms_key[each.key].id

  lifecycle {
    ignore_changes = [target_key_id]
  }
}
