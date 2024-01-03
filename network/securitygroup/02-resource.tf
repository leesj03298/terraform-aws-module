data "aws_region" "current" {}

### AWS Security Group
resource "aws_security_group" "default" {
  for_each    = { for scg in local.SecurityGroup_Optimize : scg.identifier => scg if length(local.SecurityGroup_Optimize) != 0 }
  vpc_id      = var.vpc_id[each.value.vpc_identifier]
  name        = join("-", ["scg", local.middle_name, each.value.name_prefix])
  description = each.value.description
  tags = merge(each.value.tags, {
    "Name" = join("-", ["scg", local.middle_name, each.value.name_prefix])
  })
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


locals {
  scg_ids                    = { for key, scg in aws_security_group.default : key => scg.id if length(aws_security_group.default) != 0 }
  create_security_group_rule = length(var.security_group_rule) != 0 ? true : false
}

resource "aws_security_group_rule" "sgr_cidr_blocks" {
  for_each = { for sgr in var.security_group_rule : "${sgr.securitygroup}_${sgr.portrange}_${sgr.source}" => sgr
  if alltrue([local.create_security_group_rule, can(regex("[0-9]+.[0-9]+.[0-9]+.[0-9]+/[0-9]+", sgr.source))]) }
  security_group_id        = local.scg_ids[each.value.securitygroup]
  type                     = each.value.type
  from_port                = each.value.protocol == "icmp" ? -1 : split("-", each.value.portrange)[0]
  to_port                  = each.value.protocol == "icmp" ? -1 : can(split("-", each.value.portrange)[1]) ? split("-", each.value.portrange)[1] : split("-", each.value.portrange)[0]
  protocol                 = each.value.protocol
  cidr_blocks              = [each.value.source]
  description              = each.value.description
  source_security_group_id = null
  ipv6_cidr_blocks         = null
  prefix_list_ids          = null
}

resource "aws_security_group_rule" "sgr_source_security_group_id" {
  for_each = { for sgr in var.security_group_rule : "${sgr.securitygroup}_${sgr.portrange}_${sgr.source}" => sgr
  if alltrue([local.create_security_group_rule, can(regex("[0-9a-zA-Z]+-", sgr.source))]) }
  security_group_id        = local.scg_ids[each.value.securitygroup]
  type                     = each.value.type
  from_port                = each.value.protocol == "icmp" ? -1 : split("-", each.value.portrange)[0]
  to_port                  = each.value.protocol == "icmp" ? -1 : can(split("-", each.value.portrange)[1]) ? split("-", each.value.portrange)[1] : split("-", each.value.portrange)[0]
  protocol                 = each.value.protocol
  source_security_group_id = local.scg_ids[each.value.source]
  description              = each.value.description
  cidr_blocks              = null
  ipv6_cidr_blocks         = null
  prefix_list_ids          = null
}