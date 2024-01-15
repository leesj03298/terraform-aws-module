variable "middle_name" {
    description = "Name Tags Middle Name(*Ex : join('-', ['vpc', var.middle_name, each.value.name_prefix]))"
    type        = string
}

variable "vpc_id" {
    description = "The id of the VPC"
    type        = map(string)
}

variable "sub_id" {
    description = "The id of the Subnet"
    type        = map(string)
}

variable "rtb_id" {
    description = "The id of the Route Table"
    type        = map(string)
}

variable "scg_id" {
    description = "The id of the Security Group"
    type        = map(string)
}

variable "vpcendpoint_gateway" {
    type    = list(object({
        vpc_identifier      = optional(string, null)
        rtb_identifier      = optional(list(string), null)
        identifier          = optional(string, null)
        name_prefix         = optional(string, null)
        service_name        = optional(string, null)
        tags                = optional(map(string), null)
    }))
    default = [ {
      
    } ]
}

variable "vpcendpoint_interface" {
    type    = list(object({
        vpc_identifier          = optional(string, null)
        sub_identifier          = optional(list(string), null)
        scg_identifier          = optional(list(string), null)
        service                 = optional(list(object({
            identifier          = optional(string, null)
            name_prefix             = optional(string, null)
            service_name            = optional(string, null)
            private_dns_enabled     = optional(bool, true)
            tags                    = optional(map(string), null)
        })), null)
    }))
    default = [ {
      
    } ]
}