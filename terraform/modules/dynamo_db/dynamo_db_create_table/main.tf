# ---------------------------------------------------------------------------------------------------------------------
# AMAZON DYNAMODB MODULE FOR CREATING AND CONFIGURING SERVICE RESOURCES.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_dynamodb_table" "tables_configuration" {
  for_each = var.dynamo_tables

  name           = each.value.dynamo_table_name
  billing_mode   = each.value.dynamodb_billing_mode
  read_capacity  = each.value.dynamo_read_capacity
  write_capacity = each.value.dynamo_write_capacity
  hash_key       = each.value.dynamo_hash_key
  range_key      = each.value.dynamo_source_key == "" ? null : each.value.dynamo_source_key

  dynamic "attribute" {
    for_each = each.value.dynamo_attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled     = each.value.encription_enabled != null ? each.value.encription_enabled : false
    kms_key_arn = each.value.kms_key_name != null ? lookup(var.kms_resources, each.value.kms_key_name, {}).arn : null
  }

  dynamic "ttl" {
    for_each = each.value.dynamo_ttl_atribute != null ? [1] : []
    content {
      attribute_name = each.value.dynamo_ttl_atribute
      enabled        = true
    }
  }

}
