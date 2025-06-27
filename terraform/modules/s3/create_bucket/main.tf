# ---------------------------------------------------------------------------------------------------------------------
# AWS S3
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "zones" {
  for_each = var.buckets_data
  bucket   = each.value.bucket_name
}

resource "aws_s3_bucket_public_access_block" "permissions" {
  for_each = aws_s3_bucket.zones
  bucket   = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kms_encription" {
  for_each = var.buckets_data
  bucket   = aws_s3_bucket.zones[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_keys_data[each.value.key_name].arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  for_each = { for k, v in var.buckets_data : k => v if try(v.policy_path, null) != null }
  bucket   = aws_s3_bucket.zones[each.key].id
  policy = templatefile(each.value.policy_path,
    {
      VAR_REPLACE_environment = var.environment
      VAR_REPLACE_region      = var.region
      VAR_REPLACE_aws_account = var.aws_account
    }
  )
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  for_each = var.buckets_data
  bucket   = aws_s3_bucket.zones[each.key].id
  versioning_configuration {

    status     = each.value.s3_versioning != null ? each.value.s3_versioning : null
    mfa_delete = each.value.mfa_delete == true ? "Enabled" : "Disabled"
  }
}

# resource "aws_s3_bucket_logging" "logging_access" {
#   for_each      = { for k, v in var.buckets_data : k => v if v.s3_logging_config } 
#   bucket        = each.value.id
#   target_bucket = "${each.value.id}-access-log"
#   target_prefix = "log/"
# }