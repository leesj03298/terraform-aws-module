#### Share Variable 
variable "middle_name" {
  description = "Name Tags Middle Name(*Ex : join('-', ['vpc', var.middle_name, each.value.name_prefix]))"
  type        = string
}

variable "scg_id" {
  description = "The id of the SecurityGroups"
  type        = map(string)
}

#### Redshift
variable "name_prefix" {
  description = "Resource Identifier"
  type        = string
  default     = "Example"
}

variable "database_name" {
  description = "The name of the first database to be created when the cluster is created."
  type        = string
  default     = "dev"
}

variable "master_username" {
  description = "Username for the master DB user."
  type        = string
  default     = "awsuser"
}

variable "master_password" {
  description = "Password for the master DB user."
  type        = string
  default     = "Test0574"
  sensitive   = true
}

variable "port" {
  description = "The port number on which the cluster accepts incoming connections."
  type        = number
  default     = 5439
}

variable "vpc_security_group_identifiers" {
  description = "A list of Virtual Private Cloud (VPC) security groups to be associated with the cluster."
  type        = list(string)
  default     = []
}

variable "cluster_subnet_group_name" {
  description = "The name of a cluster subnet group to be associated with this cluster."
  type        = string
  default     = null
}

variable "cluster_parameter_group_name" {
  description = "The name of the parameter group to be associated with this cluster."
  type        = string
  default     = null
}

variable "node_type" {
  description = "The node type to be provisioned for the cluster."
  type        = string
  default     = "dc2.large"
}

variable "number_of_nodes" {
  type    = number
  default = 1
  validation {
    condition = var.number_of_nodes > 0
    error_message = "Number of nodes must be at least 1."
  }
}

variable "cluster_type" {
  description = "The cluster type to use. Either single-node or multi-node."
  type        = string
  default     = "single-node"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final snapshot of the cluster is created before Amazon Redshift deletes the cluster."
  type        = bool
  default     = true
}

variable "enhanced_vpc_routing" {
  type    = bool
  default = false
}

variable "publicly_accessible" {
  type    = bool
  default = true
}

variable "availability_zone_relocation_enabled" {
  type    = bool
  default = false
}

variable "availability_zone" {
  type    = string
  default = null
}

variable "default_iam_role_name" {
  type    = string
  default = null
}

variable "iam_role_names" {
  type    = list(string)
  default = []
}