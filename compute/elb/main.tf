locals {
    share_tags = var.Share_Tag
    #### TARGET_GROUP_ATTACHMENT_LIST : aws_lb_target_group_attachment List
    TARGET_GROUP_ATTACHMENT_LIST = flatten([for Target_Group in var.Target_Group : [
        for target_identifier in Target_Group.target_identifiers : {
            target_group_identifier             = "${Target_Group.identifier}"
            target_group_attachment_identifier  = "${Target_Group.identifier}_${target_identifier}_${Target_Group.port}"
            target_identifier                   = target_identifier
            port                                = Target_Group.port
            target_type                         = Target_Group.target_type
            tags                                = merge(local.share_tags["tg"], { "Name" = "${local.share_tags["tg"].Name}-${Target_Group.name_prefix}" }, Target_Group.tags)
        }
    ] if Target_Group.target_identifiers != null ])  

    #### NETWORK_LOAD_BALANCER_LISTENER_LIST : aws_lb_listener List
    NETWORK_LOAD_BALANCER_LISTENER_LIST = flatten([for Network_Load_Balancer in var.Network_Load_Balancer : [
        for Listener in Network_Load_Balancer.Listener : {
            listener_identifier             = "${Network_Load_Balancer.identifier}_${Listener.protocol}_${Listener.port}"
            lb_identifier                   = "${Network_Load_Balancer.identifier}"
            protocol                        = Listener.protocol
            port                            = Listener.port
            ssl_policy                      = Listener.ssl_policy
            certificate_arn                 = Listener.certificate_arn
            default_action                  = {
                type                            = Listener.default_action["type"]
                target_identifier               = Listener.default_action["target_identifier"]
            }
        }
    ] if Network_Load_Balancer.Listener != null ])  

    #### APPLICATION_LOAD_BALANCER_LISTENER_LIST : aws_lb_listener List
    APPLICATION_LOAD_BALANCER_LISTENER_LIST = flatten([for Application_Load_Balancer in var.Application_Load_Balancer : [
        for Listener in Application_Load_Balancer.Listener : {
            listener_identifier             = "${Application_Load_Balancer.identifier}_${Listener.protocol}_${Listener.port}"
            lb_identifier                   = "${Application_Load_Balancer.identifier}"
            protocol                        = Listener.protocol
            port                            = Listener.port
            ssl_policy                      = Listener.ssl_policy
            certificate_arn                 = Listener.certificate_arn
            default_action                  = {
                type                            = Listener.default_action["type"]
                target_identifier               = Listener.default_action["target_identifier"]
                redirect                    = Listener.default_action.redirect == null ? null : {
                    port                        = lookup(Listener.default_action.redirect, "port", null)
                    protocol                    = lookup(Listener.default_action.redirect, "protocol", null)
                    status_code                 = lookup(Listener.default_action.redirect, "status_code", null)
                }
                fixed_response              = Listener.default_action.fixed_response == null ? null : {
                    content_type                = lookup(Listener.default_action.fixed_response, "content_type", null)
                    message_body                = lookup(Listener.default_action.fixed_response, "message_body", null)
                    status_code                 = lookup(Listener.default_action.fixed_response, "status_code", null)
                }
            }
        }
    ] if Application_Load_Balancer.Listener != null ])  
}


#### LOAD BALANCER ##############################################################################################################
resource "aws_lb" "Network_Load_Balancer" {
    for_each                = { for Network_Load_Balancer in var.Network_Load_Balancer : "${Network_Load_Balancer.identifier}" => Network_Load_Balancer }
    name                    = "${local.share_tags["nlb"].Name}-${each.value.name_prefix}"
    internal                = each.value.internal         
    load_balancer_type      = "network"
    dynamic "subnet_mapping" {
        for_each    = each.value.subnet_mapping
        content {
            subnet_id               = lookup(subnet_mapping.value, "subnet_identifier", null) != null ? var.sub_id["${subnet_mapping.value.subnet_identifier}"] : null
            private_ipv4_address    = lookup(subnet_mapping.value, "private_ipv4_address", null)
            allocation_id           = lookup(subnet_mapping.value, "allocation_id", null)
            ipv6_address            = lookup(subnet_mapping.value, "ipv6_address", null)
            outpost_id              = lookup(subnet_mapping.value, "outpost_id", null)
        }
    }
    tags                    = merge(local.share_tags["nlb"], { "Name" = "${local.share_tags["nlb"].Name}-${each.value.name_prefix}" }, each.value.tags)
}

resource "aws_lb" "Application_Load_Balancer" {
    for_each                = { for Application_Load_Balancer in var.Application_Load_Balancer : "${Application_Load_Balancer.identifier}" => Application_Load_Balancer }
    name                    = "${local.share_tags["alb"].Name}-${each.value.name_prefix}"
    internal                = each.value.internal           
    load_balancer_type      = "application"
    security_groups         = [ for scg_identifier in each.value.scg_identifiers : var.scg_id["${scg_identifier}" ] ]
    dynamic "subnet_mapping" {
        for_each    = each.value.subnet_mapping
        content {
            subnet_id               = lookup(subnet_mapping.value, "subnet_identifier", null) != null ? var.sub_id["${subnet_mapping.value.subnet_identifier}"] : null
            private_ipv4_address    = lookup(subnet_mapping.value, "private_ipv4_address", null)
            allocation_id           = lookup(subnet_mapping.value, "allocation_id", null)
            ipv6_address            = lookup(subnet_mapping.value, "ipv6_address", null)
            outpost_id              = lookup(subnet_mapping.value, "outpost_id", null)
        }
    }
    tags                    = merge(local.share_tags["alb"], { "Name" = "${local.share_tags["alb"].Name}-${each.value.name_prefix}" }, each.value.tags)
}

#### TARGET GROUP ###############################################################################################################
resource "aws_lb_target_group" "this" {
    for_each                = { for Target_Group in var.Target_Group : "${Target_Group.identifier}" => Target_Group }
    name                    = "${local.share_tags["tg"].Name}-${each.value.name_prefix}"
    protocol                = upper(each.value.protocol)
    port                    = each.value.port
    target_type             = each.value.target_type
    vpc_id                  = var.vpc_id["${each.value.vpc_identifier}"]
    tags                    = each.value.tags
}

resource "aws_lb_target_group_attachment" "this" {
    for_each                = { for TARGET_GROUP_ATTACHMENT in local.TARGET_GROUP_ATTACHMENT_LIST : "${TARGET_GROUP_ATTACHMENT.target_group_attachment_identifier}" => TARGET_GROUP_ATTACHMENT 
                                if TARGET_GROUP_ATTACHMENT.target_type == "instance"}
    target_group_arn        = lookup(aws_lb_target_group.this["${each.value.target_group_identifier}"], "arn", null ) 
    target_id               = var.ec2_id["${each.value.target_identifier}"]
    port                    = lookup(each.value, "port", null)
}


#### LISTENER ###################################################################################################################
resource "aws_lb_listener" "Network_Load_Balancer_Listener" {
    for_each            = { for LISTENER in local.NETWORK_LOAD_BALANCER_LISTENER_LIST : "${LISTENER.listener_identifier}" => LISTENER 
                            if contains(["TCP", "UDP","TCP_UDP", "TLS"], "${upper(LISTENER.protocol)}")}
    load_balancer_arn   = aws_lb.Network_Load_Balancer["${each.value.lb_identifier}"].arn
    protocol            = upper(each.value.protocol)
    port                = each.value.port
    ssl_policy          = upper(each.value.protocol) == "TLS" ? each.value.ssl_policy : null
    certificate_arn     = upper(each.value.protocol) == "TLS" ? each.value.certificate_arn : null
    default_action {
        type                = each.value.default_action["type"]
        target_group_arn    = aws_lb_target_group.this["${each.value.default_action["target_identifier"]}"].arn
    }
}

resource "aws_lb_listener" "Application_Load_Balancer_Listener_Forward" {
    for_each            = { for LISTENER in local.APPLICATION_LOAD_BALANCER_LISTENER_LIST : "${LISTENER.listener_identifier}" => LISTENER 
                            if contains(["HTTP", "HTTPS"], "${upper(LISTENER.protocol)}") && LISTENER.default_action["type"] == "forward" }
    load_balancer_arn   = aws_lb.Application_Load_Balancer["${each.value.lb_identifier}"].arn
    protocol            = upper(each.value.protocol)
    port                = each.value.port
    ssl_policy          = upper(each.value.protocol) == "HTTPS" ? each.value.ssl_policy : null
    certificate_arn     = upper(each.value.protocol) == "HTTPS" ? each.value.certificate_arn : null
    default_action {
        type                = each.value.default_action["type"]
        target_group_arn    = aws_lb_target_group.this["${each.value.default_action["target_identifier"]}"].arn
    }
}

resource "aws_lb_listener" "Application_Load_Balancer_Listener_Redirect" {
    for_each            = { for LISTENER in local.APPLICATION_LOAD_BALANCER_LISTENER_LIST : "${LISTENER.listener_identifier}" => LISTENER 
                            if contains(["HTTP", "HTTPS"], "${upper(LISTENER.protocol)}") && LISTENER.default_action["type"] == "redirect" }
    load_balancer_arn   = aws_lb.Application_Load_Balancer["${each.value.lb_identifier}"].arn
    protocol            = upper(each.value.protocol)
    port                = each.value.port
    ssl_policy          = upper(each.value.protocol) == "HTTPS" ? each.value.ssl_policy : null
    certificate_arn     = upper(each.value.protocol) == "HTTPS" ? each.value.certificate_arn : null
    default_action {
        type                = each.value.default_action["type"]
        redirect {
            port            = each.value.default_action.redirect != null ? each.value.default_action.redirect["port"] : null
            protocol        = each.value.default_action.redirect != null ? each.value.default_action.redirect["protocol"] : null
            status_code     = each.value.default_action.redirect != null ? each.value.default_action.redirect["status_code"] : null
        }
    }
}

resource "aws_lb_listener" "Application_Load_Balancer_Listener_Fixed-Response" {
    for_each            = { for LISTENER in local.APPLICATION_LOAD_BALANCER_LISTENER_LIST : "${LISTENER.listener_identifier}" => LISTENER 
                            if contains(["HTTP", "HTTPS"], "${upper(LISTENER.protocol)}") && LISTENER.default_action["type"] == "fixed-response" }
    load_balancer_arn   = aws_lb.Application_Load_Balancer["${each.value.lb_identifier}"].arn
    protocol            = upper(each.value.protocol)
    port                = each.value.port
    ssl_policy          = upper(each.value.protocol) == "HTTPS" ? each.value.ssl_policy : null
    certificate_arn     = upper(each.value.protocol) == "HTTPS" ? each.value.certificate_arn : null
    default_action {
        type                = each.value.default_action["type"]
        fixed_response {
            content_type    = each.value.default_action.fixed_response != null ? each.value.default_action.fixed_response["content_type"] : null
            message_body    = each.value.default_action.fixed_response != null ? each.value.default_action.fixed_response["message_body"] : null
            status_code     = each.value.default_action.fixed_response != null ? each.value.default_action.fixed_response["status_code"] : null
        }
    }
}
