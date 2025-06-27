# ---------------------------------------------------------------------------------------------------------------------
# AWS STEP FUNCTIONS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_sfn_state_machine" "state_machine" {
  for_each = var.step_functions
  name     = each.value.state_machine_name
  role_arn = "arn:aws:iam::${var.aws_account}:role/${each.value.iam_role_name}"
  definition = templatefile(
    each.value.file_path_definition,
    {
      VAR_REPLACE_aws_account            = var.aws_account,
      VAR_REPLACE_region                 = var.region,
      VAR_REPLACE_project                = var.project,
      VAR_REPLACE_subproject             = var.subproject,
      VAR_REPLACE_environment            = var.environment
      VAR_REPLACE_sns_arn_topic          = "arn:aws:sns:${var.region}:${var.aws_account}:${each.value.sns_name}"
      VAR_REPLACE_job_compaction_name    = each.value.job_name
      VAR_REPLACE_lambda_extraction_name = each.value.lambda_name
    }
  )
}
