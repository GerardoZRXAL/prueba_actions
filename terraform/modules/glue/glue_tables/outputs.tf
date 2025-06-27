# Outputs Module Glue Tables

output "glue_map_tbl_raw" {
  description = "Map Glue Landing tbls"
  value       = local.map_external_glue_raw_tables_var
}
