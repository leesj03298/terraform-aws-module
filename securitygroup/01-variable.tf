#### Share Variable 
variable "middle_name" {
  description = "Name Tags Middle Name(*Ex : join('-', ['vpc', var.middle_name, each.value.name_prefix]))"
  type        = string
}

variable "vpc_id" {
  description = "The id of the VPC"
  type        = map(string)
}

variable "securitygroups" {
  type = list(object({
    vpc_identifier = string
    scgs = optional(list(object({
      identifier  = optional(string, null)
      name_prefix = optional(string, null)
      description = optional(string, "Security Group")
      tags        = optional(map(string), null)
    })), null)
  }))
  validation {
    condition     = alltrue([for scg in var.securitygroups : scg.vpc_identifier != null])
    error_message = "vpc_identifier is a required field."
  }
}

variable "securitygroup_rules" {
  type = list(object({
    securitygroup = string
    protocol      = string
    portrange     = string
    source        = string
    description   = optional(string, " ")
    type          = optional(string, "ingress")
  }))
}