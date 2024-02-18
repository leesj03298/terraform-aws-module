
resource "aws_ec2_transit_gateway" "default" {
  for_each                        = { for tgw in var.transit_gateway : tgw.identifier => tgw }
  description                     = each.value.amazon_side_asn
  auto_accept_shared_attachments  = each.value.auto_accept_shared_attachments
  amazon_side_asn                 = each.value.amazon_side_asn
  default_route_table_association = each.value.default_route_table_association
  default_route_table_propagation = each.value.default_route_table_propagation
  dns_support                     = each.value.dns_support
  multicast_support               = each.value.multicast_support
  transit_gateway_cidr_blocks     = each.value.transit_gateway_cidr_blocks
  vpn_ecmp_support                = each.value.vpn_ecmp_support
  tags = merge(each.value.tags, {
    "Name" = join("-", ["tgw", var.middle_name, each.value.name_prefix])
  })
}

locals {
  tgw_ids = { for key, value in aws_ec2_transit_gateway.default : key => value.id }
}

# resource "aws_ec2_transit_gateway_vpc_attachment" "default" {
#   transit_gateway_id                              = "tgw_id"
#   vpc_id                                          = "vpc_id"
#   subnet_ids                                      = ["subnet_id"]
#   dns_support                                     = "enable"
#   ipv6_support                                    = "disable"
#   appliance_mode_support                          = "disable"
#   transit_gateway_default_route_table_association = each.value.amazon_side_asn
#   transit_gateway_default_route_table_propagation = bool
#   tags                                            = null
# }



