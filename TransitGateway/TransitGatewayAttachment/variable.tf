variable "middle_name" {
  type = string
}

variable "transit_gateway_attachment" {
  type = list(object({
    identifier                      = string
    name_prefix                     = string
    transit_gateway_id                              = optional(string, null)
    vpc_id                                          = optional(string, null)
    subnet_ids                                      = optional(list(string), [])
    dns_support                                     = optional(string, "enable")
    ipv6_support                                    = optional(string, "disable")
    appliance_mode_support                          = optional(string, "disable")
    transit_gateway_default_route_table_association = optional(bool, false)
    transit_gateway_default_route_table_propagation = optional(bool, false)
    tags                                            = optional(map(), {})
  }))
  validation {
    condition =  alltrue([for objects in var.transit_gateway_attachment : objects.transit_gateway_id != null])
    error_message = "Requrement : transit_gateway_id"
  }
  validation {
    condition =  alltrue([for objects in var.transit_gateway_attachment : objects.vpc_id != null])
    error_message = "Requrement : vpc_id"
  }
  validation {
    condition =  alltrue([for objects in var.transit_gateway_attachment : length(objects.subnet_ids) != 0])
    error_message = "Requrement : subnet_ids"
  }
}