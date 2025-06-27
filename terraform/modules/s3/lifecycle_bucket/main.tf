##### S3 #####
# ---------------------------------------------------------------------------------------------------------------------
# AWS S3 Lifecycle configuration
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_config" {
  for_each = var.lifecycle_data
  bucket   = var.buckets_data[each.key].id
  dynamic "rule" {
    for_each = each.value.rules
    content {
      expiration {
        days = rule.value.days_expiration
      }

      filter {
        prefix = rule.value.filter_prefix
      }
      dynamic "transition" {
        for_each = rule.value.transition
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }

      }
      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration != null ? [rule.value.noncurrent_version_expiration] : []
        content {
          noncurrent_days           = noncurrent_version_expiration.value.noncurrent_days
          newer_noncurrent_versions = noncurrent_version_expiration.value.newer_noncurrent_versions
        }
      }

      id     = rule.value.id
      status = rule.value.status
    }
  }
}
