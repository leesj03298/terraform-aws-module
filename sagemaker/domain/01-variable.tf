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

variable "scg_id" {
  description = "The id of the SecurityGroups"
  type        = map(string)
}

variable "domain_name" {
  type = string
}

variable "auth_mode" {
  type    = string
  default = "IAM"
}

variable "app_network_access_type" {
  ## app_network_access_type option : PublicInternetOnly, VpcOnly
  type    = string
  default = "PublicInternetOnly"
}

variable "vpc_identifier" {
  type = string
}

variable "subnet_identifiers" {
  type = list(string)
}

variable "execution_role" {
  ## execution_role input date type : arn
  type = string
}

### Required
variable "canvas_app_settings" {
  type = object({
    model_register_settings = optional(object({
      cross_account_model_register_role_arn = optional(string, null)
      status                                = optional(string, null)
    }), null)
    time_series_forecasting_settings = optional(object({
      amazon_forecast_role_arn = optional(string, null)
      status                   = optional(string, null)
    }), null)
    workspace_settings = optional(object({
      s3_artifact_path = optional(string, null)
      s3_kms_key_id    = optional(string, null)
    }), null)
    direct_deploy_settings = optional(object({
      status = optional(string, null)
    }), null)
    identity_provider_oauth_settings = optional(object({
      status           = optional(string, "DISABLED")
      data_source_name = optional(string, null)
      secret_arn       = optional(string, null)
    }), null)
    kendra_settings = optional(object({
      status = optional(string, null)
    }), null)
  })
  default = {
    model_register_settings          = null
    time_series_forecasting_settings = null
    workspace_settings               = null
    identity_provider_oauth_settings = {
      status = "DISABLED"
    }
  }
}

variable "r_studio_server_pro_app_settings" {
  type = object({
    user_group    = optional(string, "R_STUDIO_USER")
    access_status = optional(string, "DISABLED")
  })
  default = {
    user_group = "R_STUDIO_USER"
    ## (Optional) access_status 
    ## Indicates whether the current user has access to the RStudioServerPro app. 
    ## Valid values are ENABLED and DISABLED
    access_status = "DISABLED"
  }
}