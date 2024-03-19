variable "middle_name" {
  description = "Name Tags Middle Name(*Ex : join('-', ['vpc', var.middle_name, each.value.name_prefix]))"
  type        = string
}

variable "sub_id" {
  description = "The id of the Subnet"
  type        = map(string)
}

variable "sub_az" {
  description = "The availability_zone of the Subnet"
  type        = map(string)
}

variable "scg_id" {
  description = "The id of the Security Group"
  type        = map(string)
}

variable "lb_target_group" {
  type = list(object({
    connection_termination = optional(bool, false)
    deregistration_delay   = optional(number, 300)
    healtch_check = object({
      enabled             = optional(bool, true)
      healthy_threshold   = optional(number, 3)
      interval            = optional(number, 30)
      matcher             = optional(list(number), [])
      path                = optional(string, "/")
      port                = optional(string, "traffic-port")
      protocol            = optional(string, null)
      unhealthy_threshold = optional(number, 3)
    })
    tags = optional(map(string), null)
  }))
}


