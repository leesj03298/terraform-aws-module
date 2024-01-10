#### Share Variable 
variable "middle_name" {
  description = "Name Tags Middle Name(*Ex : join('-', ['vpc', var.middle_name, each.value.name_prefix]))"
  type        = string
}

variable "sub_id" {
  type = map(string)
}

variable "subnet_groups" {
  description = "Create Resource : Redshift Subnet Group"
  type = list(object({
    identifier         = string
    name_prefix        = string
    subnet_identifiers = optional(list(string), [])
  }))
}

variable "parameter_groups" {
  description = "Create Resource : Redshift Parameter Group"
  type = list(object({
    identifier  = string
    name_prefix = string
    family      = optional(string, "redshift-1.0")
    description = optional(string, "Managed by Terraform")
    parameter = optional(list(object({
      name  = string
      value = string
    })), [])
  }))
}