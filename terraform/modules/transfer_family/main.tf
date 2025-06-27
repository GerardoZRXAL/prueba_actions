# ---------------------------------------------------------------------------------------------------------------------
# AWS IAM ROLE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "user_role" {
  name = var.transfer_family_configuration.trans_fam_role_name

  assume_role_policy = file(var.transfer_family_configuration.trans_fam_role_file_path)

  tags = {
    ProjectName = var.project
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "aws_iam_role_policy" "policy" {
  name = var.transfer_family_configuration.trans_fam_policy_name
  role = aws_iam_role.user_role.id
  # policy = file(var.transfer_family_configuration.trans_fam_policy_file_path)
  policy = templatefile(var.transfer_family_configuration.trans_fam_policy_file_path,
    {
      VAR_REPLACE_environment = var.environment
      VAR_REPLACE_region      = var.region
      VAR_REPLACE_aws_account = var.aws_account
    }
  )
}


# ---------------------------------------------------------------------------------------------------------------------
# AWS CLOUDWATCH
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "transfer_logs" {
  name              = "${var.project}-transfer-family-logs-${var.environment}"
  retention_in_days = var.transfer_family_configuration.cloudwatch_retention_in_days
  kms_key_id        = lookup(var.kms_resources, var.transfer_family_configuration.cloudwatch_log_kms_key, null) != null ? var.kms_resources[var.transfer_family_configuration.cloudwatch_log_kms_key].arn : null
  tags = {
    ProjectName = var.project
    Environment = var.environment
    Owner       = var.owner
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS TRANSFER FAMILY
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_transfer_server" "sftp_server" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = aws_iam_role.user_role.arn
  structured_log_destinations = [
    "${aws_cloudwatch_log_group.transfer_logs.arn}:*"
  ]

  tags = {
    Name        = "tf-${var.project}-${var.environment}-server"
    ProjectName = var.project
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "aws_transfer_user" "sftp_user" {
  server_id = aws_transfer_server.sftp_server.id
  user_name = var.transfer_family_configuration.trans_fam_username
  # password  = var.transfer_family_configuration.trans_fam_password
  role           = aws_iam_role.user_role.arn
  home_directory = var.transfer_family_configuration.trans_fam_home_directory

  tags = {
    ProjectName = var.project
    Environment = var.environment
    Owner       = var.owner
  }
}

# resource "aws_transfer_access" "s3_access" {
#   external_id    = "S-1-1-12-1234567890-123456789-1234567890-1234"
#   server_id = aws_transfer_server.sftp_server.id
#   # user_name = aws_transfer_user.sftp_user.user_name
#   role = aws_iam_role.role.arn

#   home_directory = var.transfer_family_configuration.trans_fam_home_directory

#   # logging_role     = aws_iam_role.log_role.arn
#   # logging_location = aws_cloudwatch_log_group.transfer_logs.arn
# }
