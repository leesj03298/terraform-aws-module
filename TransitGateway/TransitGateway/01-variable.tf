variable "middle_name" {
  type    = string
  default = null
}

variable "transit_gateway_id" {
  type    = map(string)
  default = {}
  # validation {
  #   condition     = alltrue( [ length(var.transit_gateway_id) != 0, length(var.transit_gateway) != 0 ] )
  #   error_message = "transit_gateway_id is required and must be entered in the format { key = value }."
  # }
}

variable "vpc_id" {
  type    = map(string)
  default = {}
  # validation {
  #   condition     = length(var.vpc_id) ? true : false
  #   error_message = "vpc_id is required and must be entered in the format { key = value }."
  # }
}

variable "subnet_id" {
  type    = map(string)
  default = {}
  # validation {
  #   condition     = length(var.subnet_id) ? true : false
  #   error_message = "subnet_id is required and must be entered in the format { key = value }."
  # }
}

variable "transit_gateway" {
  type = list(object({
    identifier                      = optional(string, null)
    name_prefix                     = optional(string, null)
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
  validation {
    condition     = alltrue([for object in var.transit_gateway : object.identifier != null])
    error_message = "identifier is a required field."
  }
  validation {
    condition     = alltrue([for object in var.transit_gateway : object.name_prefix != null])
    error_message = "name_prefix is a required field."
  }
  default = []
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
    condition     = alltrue([for objects in var.transit_gateway_attachment : objects.transit_gateway_identifier != null])
    error_message = "Requrement : transit_gateway_identifier"
  }
  validation {
    condition     = alltrue([for objects in var.transit_gateway_attachment : objects.vpc_identifier != null])
    error_message = "Requrement : vpc_identifier"
  }
  validation {
    condition     = alltrue([for objects in var.transit_gateway_attachment : length(objects.subnet_identifiers) != 0])
    error_message = "Requrement : subnet_identifiers"
  }
  default = []
}

variable "transit_gateway_route_table" {
  type = list(object({
    identifier                 = optional(string, null)
    name_prefix                = optional(string, null)
    transit_gateway_identifier = optional(string, null)
    tags                       = optional(map(string), {})
  }))
  default = []
  validation {
    condition     = alltrue([for objects in var.transit_gateway_route_table : length(objects.identifier) != 0])
    error_message = "Requrement : identifier"
  }
  validation {
    condition     = alltrue([for objects in var.transit_gateway_route_table : length(objects.name_prefix) != 0])
    error_message = "Requrement : name_prefix"
  }
  validation {
    condition     = alltrue([for objects in var.transit_gateway_route_table : objects.transit_gateway_identifier != null])
    error_message = "Requrement : transit_gateway_identifier"
  }
}

variable "transit_gateway_route_table_association" {
  type = list(object({
    transit_gateway_attachment_identifier  = optional(string, null)
    transit_gateway_rotue_table_identifier = optional(string, null)
    replace_existing_association           = optional(bool, true)
  }))
  default = []
  # validation {
  #   condition     = alltrue([for objects in var.transit_gateway_route_table_association : objects.transit_gateway_attachment_identifier != null])
  #   error_message = "Requrement : transit_gateway_attachment_identifier"
  # }
  # validation {
  #   condition     = alltrue([for objects in var.transit_gateway_route_table_association : objects.transit_gateway_rotue_table_identifier != null])
  #   error_message = "Requrement : transit_gateway_rotue_table_identifier"
  # }
}

variable "transit_gateway_route_table_propagation" {
  type = list(object({
    transit_gateway_attachment_identifier  = optional(string, null)
    transit_gateway_rotue_table_identifier = optional(string, null)
  }))
  default = []
  # validation {
  #   condition     = alltrue([for objects in var.transit_gateway_route_table_propagation : objects.transit_gateway_attachment_identifier != null])
  #   error_message = "Requrement : transit_gateway_attachment_identifier"
  # }
  # validation {
  #   condition     = alltrue([for objects in var.transit_gateway_route_table_propagation : objects.transit_gateway_rotue_table_identifier != null])
  #   error_message = "Requrement : transit_gateway_rotue_table_identifier"
  # }
}

variable "transit_gateway_route" {
  type = list(object({
    destination_cidr_block                 = optional(string, null)
    transit_gateway_attachment_identifier  = optional(string, null)
    blackhole                              = optional(bool, false)
    transit_gateway_route_table_identifier = optional(string, null)
  }))
  default = []
}