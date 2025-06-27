locals {
  insert_item = flatten([
    for item in var.dynamo_insert_item : [
      for p in fileset(item.dynamo_tables_path, "*.json") : {
        dynamo_table_name = item.dynamo_table_name
        dynamo_hash_key   = item.dynamo_hash_key
        dynamo_source_key = item.dynamo_source_key
        path              = "${item.dynamo_tables_path}/${p}"
      }
    ]
  ])
}

resource "aws_dynamodb_table_item" "put_item_dynamo" {
  for_each   = { for i, item in local.insert_item : i => item }
  table_name = each.value.dynamo_table_name
  hash_key   = each.value.dynamo_hash_key
  range_key  = each.value.dynamo_source_key
  item = templatefile(
    each.value.path,
    {
      VAR_REPLACE_environment = var.environment
    }
  )
}
