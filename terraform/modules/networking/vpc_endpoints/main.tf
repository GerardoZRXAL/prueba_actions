# ---------------------------------------------------------------------------------------------------------------------
# NETWORKING MODULE FOR CREATING AND CONFIGURING SERVICE RESOURCES.
# ---------------------------------------------------------------------------------------------------------------------

# ==================== ENDPOINT =======================
# =====================================================

# resource "aws_vpc_endpoint" "conf_endpint" {
#   for_each     = var.endpoint_configurations
#   vpc_id       = each.value.endpoin_vpc_id
#   service_name = each.value.endpoin_service_name
#   # name = "${var.project_name}-${var.environment}-${each.value.endpoin_service_name}"
#   vpc_endpoint_type   = each.value.endpoint_type
#   security_group_ids  = each.value.security_groups
#   subnet_ids          = each.value.subnets_ids
#   private_dns_enabled = each.value.endpoint_private_dns_enabled
#   policy              = file(each.value.policy_path)
#   tags = {
#     Name        = "${var.project}-${var.environment}-${each.value.endpoint_name}"
#     Project     = var.project
#     Subproject  = var.subproject
#     Environment = var.environment
#     Owner       = var.owner
#     Createdby   = var.createdby
#   }
# }


# resource "aws_vpc_endpoint_route_table_association" "ass_private_ep" {
#   for_each        = var.endpoint_configurations
#   route_table_id  = var.route_table_id
#   vpc_endpoint_id = aws_vpc_endpoint.conf_endpint[each.key].id
# }

# resource "aws_vpc_endpoint_route_table_association" "ass_private_ep" {
#   for_each = {
#     for pair in setproduct(keys(var.endpoint_configurations), var.route_table_id) :
#     "${pair[0]}_${pair[1]}" => {
#       endpoint_key   = pair[0]
#       route_table_id = pair[1]
#     }
#   }

#   route_table_id  = each.value.route_table_id
#   vpc_endpoint_id = aws_vpc_endpoint.conf_endpint[each.value.endpoint_key].id
# }

# resource "aws_vpc_endpoint" "conf_endpint_interface" {
#   for_each     = var.endpoint_interface_configurations
#   vpc_id       = each.value.endpoin_vpc_id
#   service_name = each.value.endpoin_service_name
#   vpc_endpoint_type   = each.value.endpoint_type
#   security_group_ids  = each.value.security_groups
#   subnet_ids          = each.value.subnets_ids
#   private_dns_enabled = each.value.endpoint_private_dns_enabled
#   tags = {
#     Project     = var.project
#     Subproject  = var.subproject
#     Environment = var.environment
#     Owner       = var.owner
#     Createdby   = var.createdby
#   }
# }
