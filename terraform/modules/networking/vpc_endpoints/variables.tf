# ============= GENERAL VARIABLES ============= #
# ============================================= #

variable "aws_account" {
  type = string
}

variable "region" {
  type        = string
  description = "Infrastructure Deployment Region."
}

variable "project" {
  type        = string
  description = "TAG : Name of the project."
}

variable "subproject" {
  type        = string
  description = "TAG : Name of the subproject."
}

variable "environment" {
  type        = string
  description = "TAG : Environment or deployment environment."
}

variable "owner" {
  type        = string
  description = "TAG : Owner."
}

variable "createdby" {
  type        = string
  description = "TAG: Create by."
}

# variable "route_table_id" {
#   type        = string
#   description = "Route table id."
# }
variable "route_table_id" {
  description = "List of route table IDs to associate with the endpoint"
  type        = list(string)
}

# ==================== ENDPOINT =======================
# =====================================================
variable "endpoint_configurations" {
  type = map(object({
    endpoin_vpc_id               = string
    endpoint_name                = string
    endpoin_service_name         = string
    endpoint_type                = string
    security_groups              = list(string)
    subnets_ids                  = list(string)
    endpoint_private_dns_enabled = string
    policy_path                  = optional(string)
  }))
}

# # -- Endpoint-interface
# variable "endpoint_interface_configurations" {
#   type = map(object({
#     endpoin_vpc_id               = string
#     endpoint_name                = string
#     endpoin_service_name         = string
#     endpoint_type                = string
#     security_groups              = list(string)
#     subnets_ids                  = list(string)
#     endpoint_private_dns_enabled = string
#   }))
# }
