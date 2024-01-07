#### Share Variable 
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

variable "domain" {
  type = object({
    domain_name             = string
    auth_mode               = optional(string, "IAM")
    app_network_access_type = optional(string, "PublicInternetOnly")
    vpc_identifier          = optional(string, null)
    subnet_identifiers      = optional(list(string), [])
    ## app_network_access_type option : PublicInternetOnly, VpcOnly
    execution_role = string
    ## execution_role input date type : arn
  })
}