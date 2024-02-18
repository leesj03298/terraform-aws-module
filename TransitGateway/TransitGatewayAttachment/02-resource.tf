resource "aws_ec2_transit_gateway_vpc_attachment" "default" {
  for_each                                        = { for tgwa in var.transti_gateway_attachment : tgwa.identifier => tgwa }
  transit_gateway_id                              = var.transit_gateway_id[each.value.transit_gateway_identifier]
  vpc_id                                          = var.vpc_id[each.value.vpc_identifier]
  subnet_id                                       = [for subnet_identifier in each.value.subnet_identifiers : var.subnet_id[subnet_identifier]]
  dns_support                                     = each.value.dns_support
  ipv6_support                                    = each.value.ipv6_support
  appliance_mode_support                          = each.value.appliance_mode_support
  transit_gateway_default_route_table_association = each.value.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = each.value.transit_gateway_default_route_table_propagation
  tags = merge(each.value.tags,
    { "Name" = join("-", ["tgwa", var.middle_name, each.value.name_prefix]) }
  )
}