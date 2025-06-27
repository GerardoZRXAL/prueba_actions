# ---------------------------------------------------------------------------------------------------------------------
# CREATE IAM ROLES
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "permissions_config" {
  for_each = var.roles_configurations

  name               = each.value.name
  description        = each.value.description
  assume_role_policy = file(each.value.assume_role_policy_path)

  inline_policy {
    name = each.value.policie_name
    policy = templatefile(each.value.policy_path,
      {
        VAR_REPLACE_aws_account   = var.aws_account,
        VAR_REPLACE_region        = var.region,
        VAR_REPLACE_project       = var.project,
        VAR_REPLACE_subproject    = var.subproject,
        VAR_REPLACE_environment   = var.environment,
        VAR_REPLACE_short_project = var.short_project,
        VAR_REPLACE_domain        = var.domain
      }
    )
  }

}
resource "aws_iam_role_policy_attachment" "managed_policy_attachment" {
  for_each = { for key, value in var.roles_configurations : key => value if value.managed_policy_arn != null }

  role       = aws_iam_role.permissions_config[each.key].name
  policy_arn = each.value.managed_policy_arn
}
# ---------------------------------------------------------------------------------------------------------------------
# CREATE IAM POLICYS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role_policy" "permissions_assignment" {
  for_each = var.roles_configurations

  name = each.value.policie_name
  role = aws_iam_role.permissions_config[each.key].id
  policy = templatefile(each.value.policy_path,
    {
      VAR_REPLACE_aws_account   = var.aws_account,
      VAR_REPLACE_region        = var.region,
      VAR_REPLACE_project       = var.project,
      VAR_REPLACE_subproject    = var.subproject,
      VAR_REPLACE_environment   = var.environment,
      VAR_REPLACE_short_project = var.short_project,
      VAR_REPLACE_domain        = var.domain
    }
  )
}

