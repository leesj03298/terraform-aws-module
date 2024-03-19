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

variable "ec2" {
  type = list(object({
    identifier           = optional(string, null)
    name_prefix          = optional(string, null)
    ami                  = optional(string, null)
    instance_type        = optional(string, "t3.micro")
    sub_identifier       = optional(string, null)
    scg_identifier       = optional(list(string), null)
    iam_instance_profile = optional(string, null)
    user_data            = optional(string, null)
    key_name             = optional(string, null)
    public_ip            = optional(bool, false)
    private_ip           = optional(string, null)
    root_block_device    = optional(list(any), null)
    ebs_block_device = optional(list(object({
      ebs_block             = list(any)
      delete_on_termination = optional(bool, true)
      ebs_device_encrypted  = map(string)
    })), null)
    tags = optional(map(string), null)
  }))
}

variable "enis" {
  type = list(object({
    subnet_id           = optional(string, null)
    private_ips         = optional(list(string), null)
    security_groups     = optional(list(string), null)
    instance_identifier = optional(string, null)
    device_index        = optional(number, null)
  }))
  default = [{
    instance_identifier = null
  }]
}