#### Share Variable 
variable "middle_name" {
  description = "Name Tags Middle Name(*Ex : join('-', ['vpc', var.middle_name, each.value.name_prefix]))"
  type        = string
}

variable "vpcs" {
  description = "Create VPC or Internet Gateway"
  type = list(object({
    identifier           = optional(string, null)
    name_prefix          = optional(string, null)
    cidr_block           = optional(string, null)
    igw_enable           = optional(bool, false)
    enable_dns_hostnames = optional(bool, true)
    enable_dns_support   = optional(bool, true)
    instance_tenancy     = optional(string, "default")
    tags                 = optional(map(string), null)
  }))
  validation {
    condition     = alltrue([for vpc in var.vpcs : vpc.identifier != null])
    error_message = "identifier is a required field."
  }
  validation {
    condition     = alltrue([for vpc in var.vpcs : vpc.name_prefix != null])
    error_message = "name_prefix is a required field."
  }
  validation {
    condition     = alltrue([for vpc in var.vpcs : vpc.cidr_block != null])
    error_message = "cidr_block is a required field."
  }
  default = []
  
}

variable "subnets" {
  description = "Create Subnet"
  type = list(object({
    vpc_identifier         = optional(string, null)
    identifier             = optional(string, null)
    name_prefix            = optional(string, null)
    availability_zone      = optional(string, null)
    cidr_block             = optional(string, null)
    route_table_identifier = optional(string, null)
    tags                   = optional(map(string), null)
  }))
  validation {
    condition     = alltrue([for subnet in var.subnets : subnet.vpc_identifier != null])
    error_message = "vpc_identifier is a required field."
  }
  validation {
    condition     = alltrue([for subnet in var.subnets : subnet.identifier != null])
    error_message = "identifier is a required field."
  }
  validation {
    condition     = alltrue([for subnet in var.subnets : subnet.name_prefix != null])
    error_message = "name_prefix is a required field."
  }
  validation {
    condition     = alltrue([for subnet in var.subnets : subnet.availability_zone != null])
    error_message = "availability_zone is a required field."
  }
  validation {
    condition     = alltrue([for subnet in var.subnets : subnet.cidr_block != null])
    error_message = "cidr_block is a required field."
  }
  default = []
}

variable "route_tables" {
  description = "Create RouteTable"
  type = list(object({
    vpc_identifier = optional(string, null)
    identifier     = optional(string, null)
    name_prefix    = optional(string, null)
    tags           = optional(map(string), null)
  }))
    validation {
    condition     = alltrue([for route_table in var.route_tables : route_table.vpc_identifier != null])
    error_message = "vpc_identifier is a required field."
  }
  validation {
    condition     = alltrue([for route_table in var.route_tables : route_table.identifier != null])
    error_message = "identifier is a required field."
  }
  default = []
}