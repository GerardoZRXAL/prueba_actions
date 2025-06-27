
data "archive_file" "lambda_code_zip" {
  for_each = var.lambda_config

  type        = each.value.type
  source_dir  = each.value.source_dir
  output_path = each.value.output_path
}


resource "aws_lambda_layer_version" "lambda_layer" {
  for_each = { for name, config in var.lambda_config : name => config if config.needs_custom_layer }

  s3_bucket  = each.value.s3_bucket
  s3_key     = each.value.s3_key
  layer_name = each.value.custom_layer_name
  # layer_name = "${each.value.custom_layer_name}-${formatdate("YYYYMMDD", timestamp())}"
}


resource "aws_lambda_function" "configuration" {
  for_each = var.lambda_config

  function_name    = each.value.function_name
  description      = each.value.description
  handler          = each.value.handler
  runtime          = each.value.runtime
  role             = "arn:aws:iam::${var.aws_account}:role/${each.value.role_name}"
  memory_size      = each.value.memory_size
  timeout          = each.value.timeout
  filename         = data.archive_file.lambda_code_zip[each.key].output_path
  source_code_hash = data.archive_file.lambda_code_zip[each.key].output_base64sha256

  kms_key_arn = lookup(var.kms_resources, "lambda-key", null) != null ? var.kms_resources["lambda-key"].arn : null
  tracing_config {
    # mode = each.value.tracing_config
    mode = coalesce(each.value.tracing_config, "PassThrough")
  }

  layers = concat(
    # Capas personalizadas generadas por Terraform
    each.value.needs_custom_layer ? [aws_lambda_layer_version.lambda_layer[each.key].arn] : [],
    # Capas ya existentes en AWS
    each.value.needs_layer ? [for custom_layer in each.value.layers : "arn:aws:lambda:${var.region}:${custom_layer}"] : []
  )

  environment {
    variables = each.value.env_variables
  }

  vpc_config {
    subnet_ids         = each.value.subnet_ids
    security_group_ids = each.value.security_group_ids
  }
}


resource "aws_lambda_permission" "s3_event_permission" {
  for_each = var.s3_event_lambda_config

  action        = each.value.action
  function_name = aws_lambda_function.configuration[each.key].arn
  principal     = each.value.principal
  source_arn    = "arn:aws:s3:::${each.value.source_s3_bucket}"
}

resource "aws_s3_bucket_notification" "lambda_trigger" {
  for_each = var.s3_event_lambda_config

  bucket = each.value.source_s3_bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.configuration[each.key].arn
    events              = each.value.events
    filter_prefix       = each.value.filter_prefix
  }

}


resource "aws_lambda_permission" "cross_account_role" {
  # Solo crear el recurso para las configuraciones que tienen cross_account_permission
  for_each = {
    for k, v in var.lambda_config : k => v
    if try(v.additional_config.cross_account_permission, null) != null
  }

  statement_id  = each.value.function_name
  action        = each.value.additional_config.cross_account_permission.action
  function_name = each.value.function_name
  principal     = each.value.additional_config.cross_account_permission.principal
}