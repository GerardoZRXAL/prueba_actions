# ---------------------------------------------------------------------------------------------------------------------
# AWS EVENT BRIDGE S3 - Lambda
# ---------------------------------------------------------------------------------------------------------------------

# EventBridge Bus (usaremos el bus por defecto)
data "aws_cloudwatch_event_bus" "default" {
  name = "default"
}

# Reglas de EventBridge
resource "aws_cloudwatch_event_rule" "s3_event_rules" {
  count       = length(var.eventbridge_lambda_settings)
  name        = var.eventbridge_lambda_settings[count.index].name
  description = var.eventbridge_lambda_settings[count.index].description

  event_pattern = jsonencode({
    source      = ["aws.s3"]
    detail-type = ["Object Created"]
    detail = {
      bucket = {
        name = [var.eventbridge_lambda_settings[count.index].s3_bucket_name]
      }
      object = {
        key = [{
          wildcard = join("*", [
            var.eventbridge_lambda_settings[count.index].event_pattern_prefix != null ? var.eventbridge_lambda_settings[count.index].event_pattern_prefix : "",
            var.eventbridge_lambda_settings[count.index].event_pattern_suffix != null ? var.eventbridge_lambda_settings[count.index].event_pattern_suffix : ""
          ])
        }]
      }
    }
  })
}

# Obtener ARN de las funciones Lambda
data "aws_lambda_function" "target_functions" {
  count         = length(var.eventbridge_lambda_settings)
  function_name = var.eventbridge_lambda_settings[count.index].lambda_function_name
}

# Permisos para que EventBridge invoque las funciones Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  count = length(var.eventbridge_lambda_settings)

  statement_id  = "AllowExecutionFromEventBridge-${var.eventbridge_lambda_settings[count.index].name}"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.target_functions[count.index].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_event_rules[count.index].arn
}

# Target de EventBridge hacia Lambda
resource "aws_cloudwatch_event_target" "lambda_targets" {
  count = length(var.eventbridge_lambda_settings)

  rule      = aws_cloudwatch_event_rule.s3_event_rules[count.index].name
  target_id = "Target-${var.eventbridge_lambda_settings[count.index].name}"
  arn       = data.aws_lambda_function.target_functions[count.index].arn
}

# Extraer los nombres únicos de buckets S3 de la lista de reglas
locals {
  unique_bucket_names = distinct([for rule in var.eventbridge_lambda_settings : rule.s3_bucket_name])
}

# Configuración de notificaciones de EventBridge para cada bucket S3
resource "aws_s3_bucket_notification" "bucket_notifications" {
  count  = var.enable_bucket_notifications ? length(local.unique_bucket_names) : 0
  bucket = local.unique_bucket_names[count.index]

  eventbridge = true

  # Evitar conflictos con otras configuraciones de notificación que puedan existir
  # al establecer dependencias explícitas
  depends_on = [
    aws_cloudwatch_event_rule.s3_event_rules
  ]
}
