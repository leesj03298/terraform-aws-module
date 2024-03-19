locals {
    middle_name = var.middle_name
    VPC_Endpoint_Interface_Optimize = flatten([for endpoint_interface in var.vpcendpoint_interface : [for service in endpoint_interface.service : {
        vpc_identifier      = endpoint_interface.vpc_identifier
        sub_identifier      = endpoint_interface.sub_identifier
        scg_identifier      = endpoint_interface.scg_identifier
        identifier          = service.identifier
        name_prefix         = service.name_prefix
        service_name        = service.service_name
        private_dns_enabled = service.private_dns_enabled
        tags                = service.tags
    }] if endpoint_interface.service != null ])
}