# ---------------------------------------------------------------------------------------------------------------------
# AWS Elastic Container Registry (ECR)
# ---------------------------------------------------------------------------------------------------------------------

# ECR Repository
resource "aws_ecr_repository" "repository_ecr" {
  for_each             = var.ecr_mapping_resources
  name                 = "${var.project}-ecr-${var.subproject}-${each.value.ecr_repository_name}-${var.environment}"
  image_tag_mutability = each.value.ecr_tag_mutability
  image_scanning_configuration {
    scan_on_push = each.value.ecr_image_scanning
  }
  encryption_configuration {
    encryption_type = each.value.ecr_encryption_type
    kms_key         = each.value.kms_key_name != null ? lookup(var.kms_resources, each.value.kms_key_name, {}).arn : null
  }
}