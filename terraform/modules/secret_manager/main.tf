resource "aws_secretsmanager_secret" "secret_manager" {
  for_each   = var.secret_manager
  name       = each.value.secret_name
  kms_key_id = var.kms_keys_data[each.value.key_name].id
}