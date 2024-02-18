variable "middle_name" {
  type    = string
  default = null
}

variable "transit_gateway_id" {
  type    = map(string)
  default = {}
  validation {
    condition     = length(var.transit_gateway_id) ? true : false
    error_message = "transit_gateway_id is required and must be entered in the format { key = value }."
  }
}

variable "vpc_id" {
  type    = map(string)
  default = {}
  validation {
    condition     = length(var.vpc_id) ? true : false
    error_message = "vpc_id is required and must be entered in the format { key = value }."
  }
}

variable "subnet_id" {
  type    = map(string)
  default = {}
  validation {
    condition     = length(var.subnet_id) ? true : false
    error_message = "subnet_id is required and must be entered in the format { key = value }."
  }
}

variable "transit_gateway_attachment" {
  type = list(object({
    identifier                                      = optional(string, null)
    name_prefix                                     = optional(string, null)
    transit_gateway_identifier                      = optional(string, null)
    vpc_identifier                                  = optional(string, null)
    subnet_identifiers                              = optional(list(string), [])
    dns_support                                     = optional(string, "enable")
    ipv6_support                                    = optional(string, "disable")
    appliance_mode_support                          = optional(string, "disable")
    transit_gateway_default_route_table_association = optional(bool, false)
    transit_gateway_default_route_table_propagation = optional(bool, false)
    tags                                            = optional(map(string), {})
  }))
  validation {
    condition     = alltrue([for objects in var.transit_gateway_attachment : length(objects.identifier) != 0])
    error_message = "Requrement : identifier"
  }
  validation {
    condition     = alltrue([for objects in var.transit_gateway_attachment : length(objects.name_prefix) != 0])
    error_message = "Requrement : name_prefix"
  }
  validation {
    condition     = alltrue([for objects in var.transit_gateway_attachment : objects.transit_gateway_id != null])
    error_message = "Requrement : transit_gateway_id"
  }
  validation {
    condition     = alltrue([for objects in var.transit_gateway_attachment : objects.vpc_id != null])
    error_message = "Requrement : vpc_id"
  }
  validation {
    condition     = alltrue([for objects in var.transit_gateway_attachment : length(objects.subnet_ids) != 0])
    error_message = "Requrement : subnet_ids"
  }
  default = []
}