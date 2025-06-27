resource "aws_iam_instance_profile" "instance_profile" {
  for_each = var.instance_profile_configurations
  name     = each.value.name
  role     = each.value.role_name
}