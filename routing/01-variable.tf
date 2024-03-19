#### Share Variable 
variable "middle_name" {
  description = "Name Tags Middle Name(*Ex : join('-', ['vpc', var.middle_name, each.value.name_prefix]))"
  type        = string
}

variable "rtb_ids" {
  description = "The id of the RotueTable"
  type        = map(string)
}

variable "igw_ids" {
  description = "The id of the Internet Gateway"
  type        = map(string)
  default     = {}
}

variable "ngw_ids" {
  description = "The id of the NAT Gateway"
  type        = map(string)
  default     = {}
}

variable "tgw_ids" {
  description = "The id of the Transit Gateway"
  type        = map(string)
  default     = {}
}

variable "pcx_ids" {
  description = "The id of the VPC Peering Connection"
  type        = map(string)
  default     = {}
}

variable "cagw_ids" {
  description = "The id of the Carrier Gateway "
  type        = map(string)
  default     = {}
}

variable "eni_ids" {
  description = "The id of the Carrier Gateway "
  type        = map(string)
  default     = {}
}

variable "routetable_rules" {
  type = list(object({
    route_table_identifier = optional(string, null)
    destination            = optional(string, null)
    target                 = optional(string, null)
  }))
  validation {
    condition     = alltrue(flatten([for rtbr in var.routetable_rules : [rtbr.route_table_identifier != null, rtbr.destination != null, rtbr.target != null]]))
    error_message = "route_table_identifier, destination,target is a required field."
  }
}
