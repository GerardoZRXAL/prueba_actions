# ---------------------------------------------------------------------------------------------------------------------
# AWS S3 EVENT
# ---------------------------------------------------------------------------------------------------------------------

# To assign the permission to start the execution of the lambda
resource "aws_lambda_permission" "allow_bucket" {
  for_each      = var.lambda_permission_setting
  statement_id  = each.value.statement_id
  action        = each.value.action
  function_name = each.value.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = each.value.bucket_arn
}

# To assign the trigger to s3 bucket notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  for_each = var.lambda_bucket_notification_setting
  bucket   = each.value.bucket_name
  dynamic "lambda_function" {
    for_each = each.value.event_lambda_function
    content {
      lambda_function_arn = lambda_function.value["function_arn"]
      events              = ["s3:ObjectCreated:*"]
      filter_prefix       = lambda_function.value["filter_prefix"]
      filter_suffix       = lambda_function.value["filter_suffix"]
    }
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}