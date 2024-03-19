
resource "aws_ec2_transit_gateway" "default" {
  for_each                        = { for tgw in var.transit_gateway : tgw.identifier => tgw }
  description                     = each.value.description
  auto_accept_shared_attachments  = each.value.auto_accept_shared_attachments
  amazon_side_asn                 = each.value.amazon_side_asn
  default_route_table_association = each.value.default_route_table_association
  default_route_table_propagation = each.value.default_route_table_propagation
  dns_support                     = each.value.dns_support
  multicast_support               = each.value.multicast_support
  transit_gateway_cidr_blocks     = each.value.transit_gateway_cidr_blocks
  vpn_ecmp_support                = each.value.vpn_ecmp_support
  tags = merge({
    "Name" = join("-", ["tgw", var.middle_name, each.value.name_prefix])
    }, each.value.tags
  )
}

locals {
  tgw_ids = merge({ for key, value in aws_ec2_transit_gateway.default : key => value.id }, var.transit_gateway_id)
}

resource "aws_ec2_transit_gateway_vpc_attachment" "default" {
  for_each                                        = { for tgwa in var.transit_gateway_attachment : tgwa.identifier => tgwa }
  transit_gateway_id                              = local.tgw_ids[each.value.transit_gateway_identifier]
  vpc_id                                          = var.vpc_id[each.value.vpc_identifier]
  subnet_ids                                      = [for subnet_identifier in each.value.subnet_identifiers : var.subnet_id[subnet_identifier]]
  dns_support                                     = each.value.dns_support
  ipv6_support                                    = each.value.ipv6_support
  appliance_mode_support                          = each.value.appliance_mode_support
  transit_gateway_default_route_table_association = each.value.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = each.value.transit_gateway_default_route_table_propagation
  tags = merge({
    "Name" = join("-", ["tgwa", var.middle_name, each.value.name_prefix])
    }, each.value.tags
  )
}

resource "aws_ec2_transit_gateway_route_table" "default" {
  for_each           = { for tgwr in var.transit_gateway_route_table : tgwr.identifier => tgwr }
  transit_gateway_id = local.tgw_ids[each.value.transit_gateway_identifier]
  tags = merge({
    "Name" = join("-", ["tgwr", var.middle_name, each.value.name_prefix])
    }, each.value.tags
  )
}

locals {
  tgwa_ids = { for key, value in aws_ec2_transit_gateway_vpc_attachment.default : key => value.id }
  tgwr_ids = { for key, value in aws_ec2_transit_gateway_route_table.default : key => value.id }
}

resource "aws_ec2_transit_gateway_route_table_association" "default" {
  for_each                       = { for tgwra in var.transit_gateway_route_table_association : join("_", [tgwra.transit_gateway_rotue_table_identifier, tgwra.transit_gateway_attachment_identifier]) => tgwra }
  transit_gateway_attachment_id  = local.tgwa_ids[each.value.transit_gateway_attachment_identifier]
  transit_gateway_route_table_id = local.tgwr_ids[each.value.transit_gateway_rotue_table_identifier]
  replace_existing_association   = each.value.replace_existing_association
}

resource "aws_ec2_transit_gateway_route_table_propagation" "default" {
  for_each                       = { for tgwra in var.transit_gateway_route_table_propagation : join("_", [tgwra.transit_gateway_rotue_table_identifier, tgwra.transit_gateway_attachment_identifier]) => tgwra }
  transit_gateway_attachment_id  = local.tgwa_ids[each.value.transit_gateway_attachment_identifier]
  transit_gateway_route_table_id = local.tgwr_ids[each.value.transit_gateway_rotue_table_identifier]
}

resource "aws_ec2_transit_gateway_route" "default" {
  for_each                       = { for tgwr in var.transit_gateway_route : join("_", [tgwr.transit_gateway_route_table_identifier, tgwr.destination_cidr_block]) => tgwr }
  destination_cidr_block         = each.value.destination_cidr_block
  transit_gateway_attachment_id  = local.tgwa_ids[each.value.transit_gateway_attachment_identifier]
  blackhole                      = each.value.blackhole
  transit_gateway_route_table_id = local.tgwr_ids[each.value.transit_gateway_route_table_identifier]
}