#### Share Variable 
variable "Share_Middle_Name" {
  description = "Name Tags Middle Name(*Ex : join('-', ['vpc', var.Share_Middle_Name, each.value.name_prefix]))"
  type        = string
}

variable "vpc_id" {
  description = "The id of the VPC"
  type        = map(string)
}

variable "security_groups" {
  type = list(object({
    vpc_identifier = string
    securitygroups = optional(list(object({
      identifier  = optional(string, null)
      name_prefix = optional(string, null)
      description = optional(string, "Security Group")
      tags        = optional(map(string), null)
    })), null)
  }))
  validation {
    condition     = alltrue([for scg in var.security_groups : scg.vpc_identifier != null])
    error_message = "vpc_identifier is a required field."
  }
}

variable "security_group_rule" {
  type = list(object({
    securitygroup = string
    protocol      = string
    portrange     = string
    source        = string
    description   = optional(string, " ")
    type          = optional(string, "ingress")
  }))
}