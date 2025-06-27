# ---------------------------------------------------------------------------------------------------------------------
# GLUE
# ---------------------------------------------------------------------------------------------------------------------


locals {
  filtered_map = {
    for k, v in var.glue_data_quality_rules : k => v if v.data_quality_rules_file != ""
  }
}

resource "aws_glue_data_quality_ruleset" "rules_dq" {
  for_each = local.filtered_map

  name    = "${each.value.dc_glue_db_name}_${each.value.dc_glue_table_name}_dataquality"
  ruleset = file(each.value.data_quality_rules_file)

  target_table {
    database_name = each.value.dc_glue_db_name
    table_name    = each.value.dc_glue_table_name
  }
}
