variable "middle_name" {
  type = string
}

variable "transit_gateway" {
  type = list(object({
    identifier                      = string
    name_prefix                     = string
    amazon_side_asn                 = optional(number, 64512)
    auto_accept_shared_attachments  = optional(string, "disable")
    default_route_table_association = optional(string, "disable")
    default_route_table_propagation = optional(string, "disable")
    description                     = optional(string, "Transit Gateway")
    dns_support                     = optional(string, "enable")
    multicast_support               = optional(string, "disable")
    transit_gateway_cidr_blocks     = optional(list(string), [])
    vpn_ecmp_support                = optional(string, "enable")
    tags                            = optional(map(string), {})
  }))
}

