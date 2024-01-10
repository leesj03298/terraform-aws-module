locals {
  middle_name = var.middle_name
}

#### AWS Redshift Subnet Group ##################################################################################################
resource "aws_redshift_subnet_group" "default" {
  for_each = { for subgrp in var.subnet_groups : subgrp.identifier => subgrp
  if length(subgrp.subnet_identifiers) != 0 }
  name       = join("-", ["subgrp", local.middle_name, each.value.name_prefix])
  subnet_ids = [for sub_identifier in each.value.subnet_identifiers : var.sub_id[sub_identifier]]

}

#### AWS Redshift Parameter Group ###############################################################################################
resource "aws_redshift_parameter_group" "default" {
  for_each    = { for pargrp in var.parameter_groups : pargrp.identifier => pargrp }
  name        = join("-", ["pargrp", local.middle_name, each.value.name_prefix])
  family      = each.value.family
  description = each.value.description
  dynamic "parameter" {
    for_each = { for parameter in each.value.parameter : parameter.name => parameter.value
    if length(each.value.parameter) != 0 }
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}