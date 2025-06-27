# ---------------------------------------------------------------------------------------------------------------------
# Glue Database
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_glue_catalog_database" "database" {
  for_each = var.glue_database
  name     = each.value.glue_database_name
  tags     = each.value.tags
}
