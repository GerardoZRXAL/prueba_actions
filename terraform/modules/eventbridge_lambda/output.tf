output "event_rule_arns" {
  description = "ARNs de las reglas de EventBridge creadas"
  value       = aws_cloudwatch_event_rule.s3_event_rules[*].arn
}

output "event_rule_names" {
  description = "Nombres de las reglas de EventBridge creadas"
  value       = aws_cloudwatch_event_rule.s3_event_rules[*].name
}

output "lambda_function_arns" {
  description = "ARNs de las funciones Lambda objetivo"
  value       = data.aws_lambda_function.target_functions[*].arn
}

output "configured_s3_buckets" {
  description = "Lista de buckets S3 que han sido configurados con notificaciones de EventBridge"
  value       = var.enable_bucket_notifications ? local.unique_bucket_names : []
}