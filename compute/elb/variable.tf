variable "Share_Tag" {
    type    = map(map(string))
}

variable "vpc_id" {
    description = "The id of the VPC"
    type        = map(string)
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

variable "ec2_id" {
    description = "The id of the EC2 Instance"
    type        = map(string)
}

variable "Network_Load_Balancer" {
    type        = list(object({
        identifier                          = string
        name_prefix                         = string
        internal                            = bool                  
        subnet_mapping                      = list(object({
            subnet_identifier                   = string
            private_ipv4_address                = optional(string, null)
        }))
        enable_deletion_protection          = optional(bool, false)
        enable_cross_zone_load_balancing    = optional(bool, false)
        Listener                            = optional(list(object({
            protocol                            = string
            port                                = string
            ssl_policy                          = optional(string, null)
            certificate_arn                     = optional(string, null)
            default_action                      = object({
                type                                = string
                target_identifier                   = optional(string, null)
            })
        })), null)
        tags                                = optional(map(string), null)
    }))
}

variable "Application_Load_Balancer" {
    type        = list(object({
        identifier                          = string
        name_prefix                         = string
        internal                            = bool                 
        scg_identifiers                     = list(string)
        subnet_mapping                      = list(object({
            subnet_identifier                   = optional(string)
            private_ipv4_address                = optional(string, null)
        }))
        enable_deletion_protection          = optional(bool, false)
        enable_cross_zone_load_balancing    = optional(bool, false)
        Listener                            = optional(list(object({
            protocol                            = string
            port                                = string
            ssl_policy                          = optional(string, null)
            certificate_arn                     = optional(string, null)
            default_action                      = object({
                type                                = string
                target_identifier                   = optional(string, null)
                redirect                            = optional(object({
                    port                                = string
                    protocol                            = string
                    status_code                         = string
                }), null),
                fixed_response                      = optional(object({
                    content_type                        = string
                    message_body                        = string
                    status_code                         = string
                }), null)
            }) 
            })), null)
        tags                                = optional(map(string), null)
    }))
}

variable "Target_Group" {
    type        = list(object({
        identifier                  = optional(string)
        name_prefix                 = optional(string)
        vpc_identifier              = optional(string)
        protocol                    = optional(string)
        port                        = optional(string)
        target_type                 = optional(string)
        target_identifiers          = optional(list(string))
        tags                        = optional(map(string), null)
    }))
}