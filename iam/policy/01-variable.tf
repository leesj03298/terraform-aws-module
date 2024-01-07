#### Share Variable 
variable "middle_name" {
  description = "Name Tags Middle Name(*Ex : join('-', ['vpc', var.middle_name, each.value.name_prefix]))"
  type        = string
}

variable "policys" {
    type    = list(object({
        name_prefix             = string
        path                    = optional(string, "/")
        description             = optional(string, "Policy")
        policy                  = string
        tags                    = optional(map(string), null)
    }))
}

