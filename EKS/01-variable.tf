variable "eks_cluster" {
  type = list(object({
    identifier = optional(string, null)
    name       = optional(string, null)
    role_arn   = optional(string, null)
    ### vpc_config
    endpoint_private_access = optional(bool, false)
    endpoint_public_access  = optional(bool, true)
    public_access_cidrs     = optional(list(string), ["0.0.0.0/0"])
    security_group_ids      = optional(list(string), [])
    subnet_ids              = optional(list(string), [])

    access_config = optional(object({
      authentication_mode                         = optional(string, null)
      bootstrap_cluster_creator_admin_permissions = optional(bool, true)
    }), {})
    enabled_clsuter_log_types = optional(string, null)
    encryption_config         = optional(string, null)
    kubernetes_network_config = optional(object({
      service_ipv4_cidr = optional(string, null)
      ip_family         = optional(string, null)
    }), null)
    output_config = optional(object({
      control_plane_instance_type = optional(string, null)
      control_plane_placement     = optional(string, null)
      outpost_arns                = optional(string, null)
    }), {})
    version = optional(string, null)
    tags    = optional(map(string), {})
  }))
}

variable "eks_addon" {
  type = list(object({
    cluster_name                = optional(string, null)
    addon_name                  = optional(string, null)
    addon_version               = optional(string, null)
    configuration_values        = optional(map(any), {})
    resolve_conflicts_on_create = optional(string, "OVERWRITE")
    resolve_conflicts_on_update = optional(string, "OVERWRITE")
    service_account_role_arn    = optional(string, null)
    preserve                    = optional(bool, false)
  }))
  default = []
}