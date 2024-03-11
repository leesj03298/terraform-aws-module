variable "middle_name" {
  type    = string
  default = null
}

variable "vpc_id" {
  type    = map(string)
  default = {}
}

variable "sub_id" {
  type    = map(string)
  default = {}
}

variable "scg_id" {
  type    = map(string)
  default = {}
}

variable "application_load_balancer" {
  type = list(object({
    identifier                 = optional(string, null)
    name_prefix                = optional(string, null)
    internal                   = optional(bool, false)
    security_group_identifiers = optional(list(string), [])
    subnet_mapping = optional(list(object({
      subnet_identifier    = optional(string, null)
      allocation_id        = optional(string, null)
      ipv6_address         = optional(string, null)
      private_ipv4_address = optional(string, null)
    })), [])
    access_logs = optional(list(object({
      bucket_id = optional(string, null)
      prefix    = optional(string, null)
      enabled   = optional(bool, false)
    })), [])
    connection_logs = optional(list(object({
      bucket_id = optional(string, null)
      prefix    = optional(string, null)
      enabled   = optional(bool, false)
    })), [])
    enable_deletion_protection = optional(bool, false)
    tags                       = optional(map(string), {})
  }))
  default = [{

  }]
  # validation {
  #   condition     = alltrue([for objects in var.application_load_balancer : objects.name_prefix != null])
  #   error_message = "Requrement : name_prefix"
  # }
  # validation {
  #   condition     = alltrue([for objects in var.application_load_balancer : objects.name_prefix == null && length(objects.security_groups) != 0])
  #   error_message = "Requrement : To create an application load balancer, you must input one or more security groups."
  # }
}

variable "network_load_balancer" {
  type = list(object({
    identifier                 = optional(string, null)
    name_prefix                = optional(string, null)
    internal                   = optional(bool, false)
    security_group_identifiers = optional(list(string), [])
    subnet_mapping = optional(list(object({
      subnet_identifier    = optional(string, null)
      allocation_id        = optional(string, null)
      ipv6_address         = optional(string, null)
      private_ipv4_address = optional(string, null)
    })), [])

    enable_cross_zone_load_balancing = optional(bool, true)
    access_logs = optional(list(object({
      bucket_id = optional(string, null)
      prefix    = optional(string, null)
      enabled   = optional(bool, false)
    })), [])
    enable_deletion_protection = optional(bool, false)
    tags                       = optional(map(string), {})
  }))
  default = [{

  }]
  # validation {
  #   condition     = alltrue([for objects in var.network_load_balancer : objects.name != null ])
  #   error_message = "Requrement : name_prefix"
  # }
}


variable "target_group" {
  type = list(object({
    identifier     = optional(string, null)
    name_prefix    = optional(string, null)
    vpc_identifier = optional(string, null)
    protocol       = optional(string, null)
    port           = optional(string, null)
    target_type    = optional(string, null)
    target_ids     = optional(list(string), [])
    tags           = optional(map(string), {})
  }))
  default = [{

  }]
}