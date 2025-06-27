# ---------------------------------------------------------------------------------------------------------------------
# Glue Crawlers
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_glue_crawler" "glue_crawler" {
  for_each = var.glue_crawler_config

  name          = each.value.crawler_name
  database_name = each.value.database_name
  role          = "arn:aws:iam::${var.aws_account}:role/${each.value.role_arn}"

  # Target en S3 (si está definido)
  dynamic "s3_target" {
    for_each = each.value.s3_target_path != "" ? [each.value.s3_target_path] : []
    content {
      path = each.value.s3_target_path
    }
  }

  # Target en JDBC (si está definido)
  dynamic "jdbc_target" {
    for_each = each.value.jdbc_target != null ? [each.value.jdbc_target] : []
    content {
      connection_name = jdbc_target.value.connection_name
      path            = jdbc_target.value.path
      exclusions      = jdbc_target.value.exclusions
    }
  }

  # Target en DynamoDB (si está definido)
  dynamic "dynamodb_target" {
    for_each = each.value.dynamodb_target != null ? [each.value.dynamodb_target] : []
    content {
      path = dynamodb_target.value
    }
  }

  # Target en el Catálogo de Glue (si está definido)
  dynamic "catalog_target" {
    for_each = each.value.catalog_target != null ? [each.value.catalog_target] : []
    content {
      database_name = catalog_target.value.database_name
      tables        = catalog_target.value.tables
    }
  }

  # Recrawl Policy (se define directamente)
  recrawl_policy {
    recrawl_behavior = each.value.recrawl_behavior
  }

  # Solo agregar schedule si está definido
  schedule = each.value.schedule != null ? each.value.schedule : null

  # Schema Change Policy (si está definida)
  dynamic "schema_change_policy" {
    for_each = each.value.schema_change_policy != null ? [each.value.schema_change_policy] : []
    content {
      update_behavior = schema_change_policy.value.update_behavior
      delete_behavior = schema_change_policy.value.delete_behavior
    }
  }

  # Configuración avanzada (en formato JSON)
  configuration = each.value.configuration

}
