# ---------------------------------------------------------------------------------------------------------------------
# AWS EVENT BRIDGE SCHEDULER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_event_rule" "cron_tab" {
  for_each            = var.eventbridge_settings
  name                = each.value.cron_name
  description         = each.value.description
  state               = each.value.is_enabled
  schedule_expression = each.value.schedule_expression
  tags = {
    ProjectName = var.project
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "aws_cloudwatch_event_target" "invoke_step_function" {
  for_each = var.eventbridge_settings
  rule     = each.value.cron_name
  arn      = "arn:aws:states:${var.region}:${var.aws_account}:stateMachine:${each.value.step_functions_name}"
  role_arn = "arn:aws:iam::${var.aws_account}:role/${each.value.role_name}"
  input    = each.value.run_command_targets
  # force_destroy = true
  depends_on = [aws_cloudwatch_event_rule.cron_tab]
}