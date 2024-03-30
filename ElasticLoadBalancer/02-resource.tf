
resource "aws_lb" "application_load_balancer" {
  for_each           = { for alb in var.application_load_balancer : alb.identifier => alb if alb.identifier != null }
  load_balancer_type = "application"
  name               = join("-", ["alb", var.middle_name, each.value.name_prefix])
  internal           = each.value.internal
  security_groups    = [for scg_identifier in each.value.security_group_identifiers : var.scg_id[scg_identifier]]
  dynamic "subnet_mapping" {
    for_each = each.value.subnet_mapping
    content {
      subnet_id            = var.sub_id[subnet_mapping.value.subnet_identifier]
      allocation_id        = subnet_mapping.value.allocation_id
      ipv6_address         = subnet_mapping.value.ipv6_address
      private_ipv4_address = subnet_mapping.value.private_ipv4_address
    }
  }
  dynamic "access_logs" {
    for_each = each.value.access_logs
    content {
      bucket  = access_logs.value.bucket_id
      prefix  = access_logs.value.prefix
      enabled = access_logs.value.enabled
    }
  }
  dynamic "connection_logs" {
    for_each = each.value.connection_logs
    content {
      bucket  = access_logs.value.bucket_id
      prefix  = access_logs.value.prefix
      enabled = access_logs.value.enabled
    }
  }
  tags = merge({
    "Name" = join("-", ["alb", var.middle_name, each.value.name_prefix])
    },
    each.value.tags
  )
}

resource "aws_lb" "network_load_balancer" {
  for_each           = { for nlb in var.network_load_balancer : nlb.identifier => nlb if nlb.identifier != null }
  load_balancer_type = "network"
  name               = join("-", ["nlb", var.middle_name, each.value.name_prefix])
  internal           = each.value.internal
  security_groups    = [for scg_identifier in each.value.security_group_identifiers : var.scg_id[scg_identifier]]
  dynamic "subnet_mapping" {
    for_each = each.value.subnet_mapping
    content {
      subnet_id            = var.sub_id[subnet_mapping.value.subnet_identifier]
      allocation_id        = subnet_mapping.value.allocation_id
      ipv6_address         = subnet_mapping.value.ipv6_address
      private_ipv4_address = subnet_mapping.value.private_ipv4_address
    }
  }
  tags = merge({
    "Name" = join("-", ["nlb", var.middle_name, each.value.name_prefix])
    },
    each.value.tags
  )
}

resource "aws_lb_target_group" "default" {
  for_each    = { for tg in var.target_group : tg.identifier => tg if tg.identifier != null }
  name        = join("-", ["tg", var.middle_name, each.value.name_prefix])
  protocol    = upper(each.value.protocol)
  port        = each.value.port
  target_type = each.value.target_type
  vpc_id      = var.vpc_id[each.value.vpc_identifier]
  tags = merge({
    "Name" = join("-", ["tg", var.middle_name, each.value.name_prefix])
    },
    each.value.tags
  )
}


# resource "aws_lb_target_group_attachment" "this" {
#   for_each = { for TARGET_GROUP_ATTACHMENT in local.TARGET_GROUP_ATTACHMENT_LIST : "${TARGET_GROUP_ATTACHMENT.target_group_attachment_identifier}" => TARGET_GROUP_ATTACHMENT
#   if TARGET_GROUP_ATTACHMENT.target_type == "instance" }
#   target_group_arn = lookup(aws_lb_target_group.this["${each.value.target_group_identifier}"], "arn", null)
#   target_id        = var.ec2_id["${local.share_tags["ec2"].Name}-${each.value.target_id}"]
#   port             = lookup(each.value, "port", null)
# }