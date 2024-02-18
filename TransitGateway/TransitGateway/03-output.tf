### Transit Gateway ##########################################################################################################################
output "transit_gateway_id" {
  description = "The id of the TransitGateway"
  value       = { for key, value in aws_ec2_transit_gateway.default : key => value.id }
}

output "transit_gateway_description" {
  description = "The description of the TransitGateway"
  value       = { for key, value in aws_ec2_transit_gateway.default : key => value.description }
}

output "transit_gateway_association_default_route_table_id" {
  description = "The association_default_route_table_id of the TransitGateway"
  value       = { for key, value in aws_ec2_transit_gateway.default : key => value.association_default_route_table_id }
}

output "transit_gateway_propagation_default_route_table_id" {
  description = "The propagation_default_route_table_id of the TransitGateway"
  value       = { for key, value in aws_ec2_transit_gateway.default : key => value.propagation_default_route_table_id }
}

output "transit_gateway_auto_accept_shared_attachments" {
  description = "The auto_accept_shared_attachments of the TransitGateway"
  value       = { for key, value in aws_ec2_transit_gateway.default : key => value.auto_accept_shared_attachments }
}

output "transit_gateway_default_route_table_association" {
  description = "The default_route_table_association of the TransitGateway"
  value       = { for key, value in aws_ec2_transit_gateway.default : key => value.default_route_table_association }
}

output "transit_gateway_default_route_table_propagation" {
  description = "The default_route_table_propagation of the TransitGateway"
  value       = { for key, value in aws_ec2_transit_gateway.default : key => value.default_route_table_propagation }
}

output "transit_gateway_dns_support" {
  description = "The dns_support of the TransitGateway"
  value       = { for key, value in aws_ec2_transit_gateway.default : key => value.dns_support }
}

output "transit_gateway_multicast_support" {
  description = "The multicast_support of the TransitGateway"
  value       = { for key, value in aws_ec2_transit_gateway.default : key => value.multicast_support }
}

output "transit_gateway_owner_id" {
  description = "The owner_id of the TransitGateway"
  value       = { for key, value in aws_ec2_transit_gateway.default : key => value.owner_id }
}

output "transit_gateway_vpn_ecmp_support" {
  description = "The vpn_ecmp_support of the TransitGateway"
  value       = { for key, value in aws_ec2_transit_gateway.default : key => value.vpn_ecmp_support }
}