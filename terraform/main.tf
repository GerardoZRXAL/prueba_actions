terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.39.0"
    }
  }
  #A backend defines where Terraform stores its state data files.
  backend "s3" {
    bucket = "dlk-fortacero-s3-terraform-useast1-dev"
    key    = "datalake/fortacero-infra-deploy/terraform.tfstate"
    region = "us-east-1"
  }

  required_version = ">= 0.14.9"

}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project        = var.project
      ProjectName    = var.subproject
      Environment    = var.environment
      "map-migrated" = var.map_migrated
      CreatedBy      = var.createdby
      Owner          = var.owner
    }
  }
}

# KMS
module "kms" {
  source = "./modules/kms"

  aws_account      = var.aws_account
  region           = var.region
  project          = var.project
  subproject       = var.subproject
  environment      = var.environment
  owner            = var.owner
  createdby        = var.createdby
  account_consumer = var.account_consumer
  role_source      = var.role_source
  role_consumer    = var.role_consumer
  kms_data         = var.kms_data
}

# #SNS
# module "sns" {
#   source        = "./modules/sns"
#   project       = var.project
#   subproject    = var.subproject
#   environment   = var.environment
#   owner         = var.owner
#   createdby     = var.createdby
#   topics        = var.topics
#   kms_keys_data = module.kms.kms_keys_data
#   depends_on    = [module.kms]
# }

# S3
module "create_bucket" {
  source = "./modules/s3/create_bucket"

  aws_account   = var.aws_account
  region        = var.region
  project       = var.project
  subproject    = var.subproject
  environment   = var.environment
  owner         = var.owner
  createdby     = var.createdby
  buckets_data  = var.buckets_data
  kms_keys_data = module.kms.kms_keys_data

  depends_on = [module.kms]
}


# #NETWORKING
# module "vpc_endpoints" {
#   source                  = "./modules/networking/vpc_endpoints"
#   aws_account             = var.aws_account
#   project                 = var.project
#   subproject              = var.subproject
#   environment             = var.environment
#   owner                   = var.owner
#   createdby               = var.createdby
#   region                  = var.region
#   endpoint_configurations = var.endpoint_configurations
#   # endpoint_interface_configurations = var.endpoint_interface_configurations
#   route_table_id = var.route_table_id
# }


# # GLUE DATABASE
# module "glue_database" {
#   source = "./modules/glue/glue_database"

#   aws_account   = var.aws_account
#   project       = var.project
#   subproject    = var.subproject
#   environment   = var.environment
#   owner         = var.owner
#   createdby     = var.createdby
#   region        = var.region
#   glue_database = var.glue_database
# }

# # IAM
# module "iam" {
#   source = "./modules/iam/iam_roles"

#   aws_account          = var.aws_account
#   region               = var.region
#   project              = var.project
#   subproject           = var.subproject
#   environment          = var.environment
#   owner                = var.owner
#   createdby            = var.createdby
#   short_project        = var.short_project
#   domain               = var.domain
#   roles_configurations = var.roles_configurations
# }


# # DYNAMODB
# module "dynamodb" {
#   source = "./modules/dynamo_db/dynamo_db_create_table"

#   aws_account   = var.aws_account
#   region        = var.region
#   project       = var.project
#   subproject    = var.subproject
#   environment   = var.environment
#   owner         = var.owner
#   createdby     = var.createdby
#   dynamo_tables = var.dynamo_tables
#   kms_resources = module.kms.kms_keys_data

#   depends_on = [module.kms]
# }

# # DYNAMODB PUT ITEM
# module "dynamo_db_insert_item" {
#   source = "./modules/dynamo_db/dynamo_db_insert_item"

#   aws_account        = var.aws_account
#   project            = var.project
#   subproject         = var.subproject
#   environment        = var.environment
#   owner              = var.owner
#   createdby          = var.createdby
#   region             = var.region
#   dynamo_insert_item = var.dynamo_insert_item

#   depends_on = [module.dynamodb]
# }

# GLUE
# module "glue" {
#   source = "./modules/glue/glue_jobs"

#   aws_account                       = var.aws_account
#   project                           = var.project
#   subproject                        = var.subproject
#   environment                       = var.environment
#   owner                             = var.owner
#   createdby                         = var.createdby
#   region                            = var.region
#   glue_connection_name              = var.glue_connection_name
#   glue_connection_availability_zone = var.glue_connection_availability_zone
#   glue_connection_security_group    = var.glue_connection_security_group
#   glue_connection_subnet_id         = var.glue_connection_subnet_id
#   glue_etl_config                   = var.glue_etl_config
#   kms_keys_data                     = module.kms.kms_keys_data

#   depends_on = [module.kms, module.iam]
# }

# # ORCHESTRATION
# module "stepfunctions" {
#   source         = "./modules/stepfunctions"
#   aws_account    = var.aws_account
#   region         = var.region
#   project        = var.project
#   subproject     = var.subproject
#   environment    = var.environment
#   owner          = var.owner
#   createdby      = var.createdby
#   step_functions = var.step_functions
# }

# # EVENTBRIDGE
# module "eventbridge" {
#   source               = "./modules/eventbridge"
#   aws_account          = var.aws_account
#   region               = var.region
#   project              = var.project
#   subproject           = var.subproject
#   environment          = var.environment
#   owner                = var.owner
#   createdby            = var.createdby
#   eventbridge_settings = var.eventbridge_settings
#   depends_on           = [module.stepfunctions]
# }
