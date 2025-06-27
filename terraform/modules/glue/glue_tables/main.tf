# ---------------------------------------------------------------------------------------------------------------------
# Glue Tables
# ---------------------------------------------------------------------------------------------------------------------

# Staging tables
locals {
  map_external_glue_raw_tables_var = {
    for ni in var.map_external_glue_tables_raw : ni.sub_db_glue_name => ni.properties_glue_table
  }
}

resource "aws_glue_catalog_table" "aws_glue_catalog_table_raw" {
  for_each      = local.map_external_glue_raw_tables_var
  name          = each.value.dc_glue_table_name
  database_name = each.value.dc_glue_db_name
  table_type    = each.value.TableType
  parameters = {
    # EXTERNAL              = each.value.EXTERNAL
    "parquet.compression"    = each.value.parquet_compression
    "skip.header.line.count" = each.value.skip_header_line_count
    "delimiter"              = each.value.delimiter_file
  }

  storage_descriptor {
    location      = "${each.value.s3_location_bucket}${each.value.location}"
    input_format  = each.value.InputFormat
    output_format = each.value.OutputFormat
    compressed    = each.value.compressed

    ser_de_info {
      serialization_library = each.value.SerializationLibrary

      parameters = {
        "serialization.format" = each.value.serialization_format
        "path"                 = each.value.location,
        "classification"       = each.value.ser_de_info_param_classification
        "compressionType"      = each.value.ser_de_info_param_compression
      }
    }

    dynamic "columns" {
      for_each = jsondecode(file(each.value.dc_glue_table_definition)).Columns
      content {
        name    = columns.value.Name
        type    = columns.value.Type
        comment = columns.value.Comment
      }
    }
  }
  dynamic "partition_keys" {
    for_each = jsondecode(file(each.value.dc_glue_table_definition)).Partition_key
    content {
      name = partition_keys.value.Name
      type = partition_keys.value.Type
    }
  }
}
