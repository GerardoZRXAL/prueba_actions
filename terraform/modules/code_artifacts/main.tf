# ---------------------------------------------------------------------------------------------------------------------
# AWS CodeArtifact Module
# ---------------------------------------------------------------------------------------------------------------------


# Creación del dominio de CodeArtifact
resource "aws_codeartifact_domain" "codeartifacts_domain_resources" {
  for_each       = var.codeartifacts_domain_resources
  domain         = "${var.project}-codeartifacts-${var.subproject}-${each.value.codeartifact_domain_name}-${var.environment}"
  encryption_key = each.value.kms_key_name != null ? lookup(var.kms_resources, each.value.kms_key_name, {}).arn : null

  tags = {
    Name        = "${var.project}-codeartifacts-${var.subproject}-${each.value.codeartifact_domain_name}-${var.environment}"
    Project     = var.project
    Subproject  = var.subproject
    Environment = var.environment
    Owner       = var.owner
    CreatedBy   = var.createdby
  }
}

# Creación de repositorios dentro de los dominios de CodeArtifact
resource "aws_codeartifact_repository" "codeartifacts_repository_resources" {
  for_each = {
    for repo in flatten([
      for domain_key, domain in var.codeartifacts_domain_resources : [
        for repo in domain.repositories : {
          domain_key  = domain_key
          domain_name = "${var.project}-codeartifacts-${var.subproject}-${domain.codeartifact_domain_name}-${var.environment}"
          repo_name   = repo.name
          description = repo.description
          upstream    = repo.upstream_repositories
          external    = repo.external_connections
        }
      ]
    ]) : "${repo.domain_key}_${repo.repo_name}" => repo
  }

  repository   = "${var.project}-${var.subproject}-${each.value.repo_name}-${var.environment}"
  domain       = each.value.domain_name
  domain_owner = var.aws_account
  description  = each.value.description

  # Configuración de repositorios upstream
  dynamic "upstream" {
    for_each = each.value.upstream
    content {
      repository_name = upstream.value
    }
  }

  # Configuración de conexiones externas (públicas)
  dynamic "external_connections" {
    for_each = each.value.external
    content {
      external_connection_name = external_connections.value
    }
  }

  tags = {
    Name        = "${var.project}-${var.subproject}-${each.value.repo_name}-${var.environment}"
    Project     = var.project
    Subproject  = var.subproject
    Environment = var.environment
    Owner       = var.owner
    CreatedBy   = var.createdby
  }

  depends_on = [aws_codeartifact_domain.codeartifacts_domain_resources]
}
